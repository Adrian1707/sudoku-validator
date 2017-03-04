require 'pry'
require './lib/sudoku_parser'

class Validator

  INVALID = "This sudoku is invalid."
  VALID_BUT_INCOMPLETE = "This sudoku is valid, but incomplete."
  VALID = "This sudoku is valid."

  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
    @valid_but_incomplete = 0
    @invalid = 0
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def validate
    scan_rows
    scan_colunms
    scan_blocks
    return_message
  end

  private

  def return_message
    return INVALID if @invalid != 0
    return VALID_BUT_INCOMPLETE if @valid_but_incomplete != 0
    return VALID
  end

  def scan_rows
    parsed_blocks.map { |section| check_for_validity (section) }
  end

  def scan_colunms
    @columns = parsed_blocks.flatten.each_slice(9).to_a.transpose
    check_for_validity(@columns)
  end

  def scan_blocks
    @groups = parsed_blocks.flatten(1).transpose.flatten(1).each_slice(3).to_a
    check_for_validity(@groups)
  end

  def parsed_blocks
    SudokuParser.parse(@puzzle_string)
  end

  def check_for_validity(blocks)
    blocks.map do |block|
      remove_zeros(block)
      if block_is_invalid?(block)
         @invalid +=1
      elsif block_is_valid_but_incomplete?(block)
        @valid_but_incomplete += 1
      end
    end
  end

  def block_is_invalid?(block)
    if block.flatten.count(0) >= 1
      @no_zeros.flatten.length != @no_zeros.flatten.uniq.length
    else
      (block.flatten.length != block.flatten.uniq.length || block.flatten.sort != [*1..9])
    end
  end

  def block_is_valid_but_incomplete?(block)
    (@no_zeros.length == @no_zeros.uniq.length) && block.flatten.count(0) > 0
  end

  def remove_zeros(block)
    @no_zeros = block.flatten.reject {|num| num == 0}
  end

end

require 'pry'
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
    validate_rows
    validate_blocks
    validate_columns
    return INVALID if @invalid != 0

    if @valid_but_incomplete != 0
      return VALID_BUT_INCOMPLETE
    else
      return VALID
    end
  end

  def validate_columns
    convert_to_blocks
    convert_to_int
    @transposed_blocks = @blocks.flatten.each_slice(9).to_a.transpose
    increment_validity_variables(@transposed_blocks)
  end

  def validate_rows
    convert_to_blocks
    convert_to_int
    iterate_and_determine_validity
  end

  def validate_blocks
    convert_to_blocks
    convert_to_int
    @blocks_collection = @blocks.flatten(1).transpose.flatten(1).each_slice(3).to_a
    increment_validity_variables(@blocks_collection)
  end

  def convert_to_blocks
    @blocks = @puzzle_string.split("\n").reject {|row| row.include?("--")}.each_slice(3).to_a.map! do |row|
      row.map! do |string|
        string.split("|")
      end
    end
  end

  def convert_to_int
    @blocks.map! do |section|
      section.map! do |block|
        block.map! do |row|
          row.split(" ").map(&:to_i)
        end
      end
    end
  end

  def iterate_and_determine_validity
    @blocks.map! do |section|
      increment_validity_variables(section)
    end
  end

  def increment_validity_variables(blocks)
    blocks.map do |block|
      if block_is_invalid?(block)
         @invalid +=1
      elsif block_is_valid_but_incomplete?(block)
        @valid_but_incomplete += 1
      end
    end
  end

  def block_is_invalid?(block)
    if block.flatten.count(0) >= 1
      no_zeros = block.flatten.reject {|num| num == 0 }
      no_zeros.flatten.length != no_zeros.flatten.uniq.length
    else
    (block.flatten.length != block.flatten.uniq.length || block.flatten.sort != [*1..9])
    end
  end

  def block_is_valid_but_incomplete?(block)
    no_zeros = block.flatten.reject {|num| num == 0}
    (no_zeros.length == no_zeros.uniq.length) && block.flatten.count(0) > 0
  end

end

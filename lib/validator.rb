require 'pry'
require './lib/parser'
require './lib/scanner'

module Sudoku
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
      Scanner.scan_grid(parsed_blocks, self)
      return_message
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

    private

    def return_message
      return INVALID if @invalid != 0
      return VALID_BUT_INCOMPLETE if @valid_but_incomplete != 0
      return VALID
    end

    def parsed_blocks
      Parser.parse(@puzzle_string)
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
end

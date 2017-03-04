require 'pry'
class Validator

  INVALID = "This sudoku is invalid."
  VALID_BUT_INCOMPLETE = "This sudoku is valid, but incomplete."
  VALID = "This sudoku is valid."


  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def validate
    validate_rows
    validate_blocks
    # validate_columns
  end

  def validate_columns
    convert_to_blocks
    convert_to_int
  end

  def validate_rows
    convert_to_blocks
    convert_to_int
    @blocks.map! do |section|
      section.map! do |block|
        if block_is_valid_but_incomplete?(block)
          return VALID_BUT_INCOMPLETE
        elsif block_is_invalid?(block)
          return INVALID
        end
      end
    end
  end

  def validate_blocks
    convert_to_blocks
    convert_to_int

    @blocks.map! do |section|
      section.map! do |block|
        if block_is_valid_but_incomplete?(block)
          return VALID_BUT_INCOMPLETE
        elsif block_is_invalid?(block)
          return INVALID
        end
      end
    end
    return VALID
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

  def block_is_invalid?(block)
    block.flatten.length != block.flatten.uniq.length || block.flatten.sort != [*1..9] && block.flatten.count(0) < 1
  end

  def block_is_valid_but_incomplete?(block)
    no_zeros = block.flatten.reject {|num| num == 0}
    (no_zeros.length == no_zeros.uniq.length) && block.flatten.count(0) > 0
  end

end

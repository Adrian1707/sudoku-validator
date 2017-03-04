module Sudoku
  class Scanner

    def self.scan_grid(blocks, validator)
      @blocks = blocks
      @validator = validator
      scan_rows
      scan_columns
      scan_squares
    end

    def self.scan_rows
      @blocks.map { |section| @validator.check_for_validity (section) }
    end

    def self.scan_columns
      @columns = @blocks.flatten.each_slice(9).to_a.transpose
      @validator.check_for_validity(@columns)
    end

    def self.scan_squares
      @squares = @blocks.flatten(1).transpose.flatten(1).each_slice(3).to_a
      @validator.check_for_validity(@squares)
    end

  end
end

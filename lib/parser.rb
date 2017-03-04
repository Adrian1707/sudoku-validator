module Sudoku
  class Parser

    ROW_SEPERATOR = "-"
    COLUMN_SEPERATOR = "|"

    def self.parse(string)
      string.split("\n").reject {|row| row.include?(ROW_SEPERATOR)}.each_slice(3).to_a.map! do |row|
        row.map! do |string|
          string.split(COLUMN_SEPERATOR).map! do |str|
            str.split(" ").map(&:to_i)
          end
        end
      end
    end

  end
end

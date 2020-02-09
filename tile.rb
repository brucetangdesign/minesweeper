require "colorize"

class Tile
    attr_reader :value, :face, :flagged
    MINE_CHAR = "\u2297".colorize(:red)
    CLEAR_CHAR = "\u2588".colorize(:light_black)

    def initialize(value)
        @value = (value == "mine") ? MINE_CHAR : (value == "clear") ? CLEAR_CHAR : value
        @face = "\u2588"
        @flagged = false
    end

    def flag
        @face = "\u224B"
    end

    def reveal
        @value
    end
end
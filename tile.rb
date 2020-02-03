require "colorize"

class Tile
    attr_reader :value, :face, :flagged
    MINE_CHAR = "\u2297"

    def initialize(value="")
        @value = (value == "mine") ? MINE_CHAR : value
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
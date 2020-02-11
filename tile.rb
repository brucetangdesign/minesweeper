require "colorize"

class Tile
    attr_reader :value, :face, :flagged
    MINE_CHAR = "\u2297".colorize(:red)
    CLEAR_CHAR = "\u2588".colorize(:light_black)
    DEFAULT_FACE = "\u2588"

    def initialize(value)
        @value = (value == "mine") ? MINE_CHAR : (value == "clear") ? CLEAR_CHAR : value
        @face = DEFAULT_FACE
        @flagged = false
    end

    def flag(show_flag = true)
        @face = "\u224B"
        @flagged = true
    end

    def unflag
        @face = DEFAULT_FACE
        @flagged = false
    end

    def reveal
        @face = @value
    end
end
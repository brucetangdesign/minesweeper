require "colorize"

class Tile
    attr_reader :value, :face, :flagged
    MINE_CHAR = "\u2297"
    CLEAR_CHAR = "\u2588".colorize(:green)
    DEFAULT_FACE = "\u2588"

    def initialize(value)
        @value = value
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

    def valid_tile
        @value != "mine"
    end

    def reveal(current_selection = false)
        case @value
        when "mine"
        @face = MINE_CHAR.colorize(:red)
        @face = MINE_CHAR.colorize(:color => :black, :background => :red) if current_selection && @value == "mine"
        when "clear"
        @face = CLEAR_CHAR
        else
        @face = @value.to_s.colorize(:green)
        end

        return @value
    end
end
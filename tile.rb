require "colorize"

class Tile
    attr_reader :value, :face, :flagged
    MINE_CHAR = "\u2297"
    CLEAR_CHAR = "\u2588".colorize(:light_black)
    DEFAULT_FACE = "\u2588"
    FLAG_CHAR = "\u224B".colorize(:color => :magenta, :background => :white)

    def initialize(value)
        @value = value
        @face = DEFAULT_FACE
        @flagged = false
        @revealed = false
    end

    def flag
        @face = !@flagged ? FLAG_CHAR : DEFAULT_FACE
        @flagged = !@flagged 
    end

    def valid_tile
        @value != "mine"
    end

    def revealed?
        @revealed
    end

    def reveal(current_selection = false)
        case @value
        when "mine"
        @face = MINE_CHAR.colorize(:red)
        @face = MINE_CHAR.colorize(:color => :black, :background => :red) if current_selection && @value == "mine"
        when "clear"
        @face = CLEAR_CHAR
        else
            val_str = @value.to_s
            case val_str
            when "1"
                @face = val_str.colorize(:blue)
            when "2"
                @face = val_str.colorize(:green)
            else
                @face = val_str.colorize(:red)
            end
        end

        @revealed = true

        return @value
    end
end
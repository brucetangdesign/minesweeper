require "colorize"

class Tile
    attr_reader :value, :face
    def initialize
        @value = ""
        @face = "\u2588"
    end

    def flag
        @face = "\u0224B"
    end

    def reveal
        @value
    end
end
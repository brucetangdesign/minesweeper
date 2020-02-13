require_relative "./board.rb"

class Game
    def initialize
        @board = Board.new(9)
    end

    def play
        @board.render
    end
end

game = Game.new
game.play
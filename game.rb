require_relative "./board.rb"

class Game
    def initialize
        @board = Board.new(9)
    end

    def get_pos_and_move
        pos = nil
        move = nil

        until pos && valid_pos?(pos) && move && valid_move?(move)
            puts "\nEnter a coordinate separated by a comma, followed by a space and then -r to reveal or -f to flag (ex. 3,4 -r)"
            pos, move = gets.chomp.strip.split(" ")
            exit! if pos == "exit"
        end
        
        [pos,move]
    end

    def valid_pos?(pos)
    end

    def valid_move?(move)
    end

    def take_turn
        pos, move = get_pos_and_move
        p pos
        p move
    end

    def play
        system("clear")
        @board.render

        take_turn
    end

    def run
        play until won? || lost?

        puts ""
        puts "=".ljust(40,"=")
        puts "=".ljust(40,"=")
        puts ""
        
        puts "CONGRATULATIONS, YOU WON!" if won?
        puts "BOOOOOOM, YOU'RE DEAD!" if lost?
        
        puts ""
        puts "=".ljust(40,"=")
        puts "=".ljust(40,"=")
    end

    def won?
        @board.all_clears_revealed?
    end

    def lost?
        @board.any_mines_revealed?
    end
end

game = Game.new
game.run
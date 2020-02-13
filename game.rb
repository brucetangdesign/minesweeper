require "colorize"
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

            begin
                pos = parsePos(pos)
            rescue => e
                puts e.to_s.colorize(:red)
                puts ""

                pos = nil
            end

            begin
                valid_move?(move)
            rescue => e
                puts e.to_s.colorize(:red)
                puts ""

                move = nil
            end
        end
        
        [pos,move]
    end

    def parsePos(pos)
        raise "You're missing a comma" if !pos.include?(",")
        pos_arr = pos.split(",")
        raise "You can only enter numbers for the position" if pos_arr.any?{ |coord| coord.to_i.to_s != coord }
        raise "Please enter 2 numbers separated by a comma" if pos_arr.length != 2
        pos_arr.map {|coord| coord.to_i }
    end

    def valid_pos?(pos)
        return @board.valid_pos?(pos)
    end

    def valid_move?(move)
        raise "Invalid move (use -r to reveal or -f to flag)" if move != "-r" && move != "-f"
        return false if move != "-r" && move != "-f"
        true
    end

    def take_turn
        pos, move = get_pos_and_move

        @board.reveal(pos) if move == "-r"
        @board.flag(pos) if move == "-f"
    end

    def play
        system("clear")
        @board.render

        take_turn
    end

    def run
        play until won? || lost?
        system("clear")
        @board.render

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

    def cheat
        @board.clear
        @board.reveal_mines
        @board.render
    end
end

game = Game.new
game.run
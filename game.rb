require "colorize"
require 'yaml'
require_relative "./board.rb"

class Game
    def initialize
        @board = Board.new(9)
        @saving = false

        prompt_user
    end

    def prompt_user
        user_input = nil
        valid_file = false

        until user_input && (user_input == "new" || valid_file)
            puts "Type \"new\" to start a new game. To load a saved game type the filename."
            user_input = gets.chomp.strip

            exit! if user_input == "exit"
            run if user_input == "new"

            case user_input
            when "exit"
                exit!
            when "new"
                run
            else
                begin
                    valid_file = load_file(user_input)
                rescue => e
                    puts e.to_s.colorize(:red)
                    puts ""

                    valid_file = nil
                end
            end
        end
    end

    def load_file(file_name)
        raise "File not found" if !File.exists?(file_name)
        raise "Invalid file (only .yml files are allowed)" if !file_name.include? (".yml")
        @board = YAML.load(File.read(file_name))
        run
    end

    def get_pos_and_move
        pos = nil
        move = nil

        until pos && valid_pos?(pos) && move && valid_move?(move)
            puts "\nEnter a coordinate separated by a comma, followed by a space and then -r to reveal or -f to flag (ex. 3,4 -r)"
            pos, move = gets.chomp.strip.split(" ")
            exit! if pos == "exit"
            if pos == "save"
                @saving = true
                return
            end

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
        play until won? || lost? || @saving
        system("clear")
        @board.render

        if !@saving
            puts ""
            puts "=".ljust(40,"=")
            puts "=".ljust(40,"=")
            puts ""
            
            puts "CONGRATULATIONS, YOU WON!" if won?
            puts "BOOOOOOM, YOU'RE DEAD!" if lost?
            
            puts ""
            puts "=".ljust(40,"=")
            puts "=".ljust(40,"=")
        else
            save_game
        end
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

    def save_game
        puts ""
        puts "=".ljust(40,"=")
        puts "=".ljust(40,"=")
        puts ""
        puts "Enter a file name"
        
        file_name = gets.chomp.strip

        File.open("#{file_name}.yml", "w") { |file| file.write(@board.to_yaml) }
        exit!
    end
end

game = Game.new
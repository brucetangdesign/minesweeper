require_relative "tile.rb"
require "colorize"

class Board
    attr_reader :grid

    def initialize(grid_size, num_mines = 10)
        @grid = []

        (0...grid_size).each do |i|
            @grid << []
            (0...grid_size).each do |j|
                @grid[i] << Tile.new()
            end
        end

        set_mine_positions(num_mines)
    end

    def set_mine_positions(num_mines)
        possible_positions = []
        mine_positions = []
        # store all possible positions
        (0...@grid.count).each { |i| (0...@grid.count).each { |j| possible_positions << [i,j] } }

        #get a random setopf coordinates to place mines at
        num_mines.times do
            random_position = possible_positions.sample
            mine_positions << random_position
            possible_positions.delete(random_position)
        end
    end

    def render
        puts "  #{[*0...@grid.count].join(" ")}"

        (0...@grid.count).each do |i|
            row = @grid[i].map {|tile| tile.face}.join(" ")
            puts "#{i} #{row.colorize(:light_black)}"
        end
    end
end

b = Board.new(9)
b.render
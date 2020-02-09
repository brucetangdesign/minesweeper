require_relative "tile.rb"
require "colorize"

class Board
    attr_reader :grid

    def initialize(grid_size, num_mines = 10)
        @grid = []
        mine_positions = set_mine_positions(grid_size, num_mines)
        #mine_neighbors = get_mine_neighbors(mine_positions, grid_size)

        (0...grid_size).each do |i|
            @grid << []
            (0...grid_size).each do |j|
                val = mine_positions.include?([i,j]) ? "mine" : "clear"
                @grid[i] << Tile.new(val)
            end
        end
    end

    def set_mine_positions(grid_size, num_mines)
        possible_positions = []
        mine_positions = []
        # store all possible positions
        (0...grid_size).each { |i| (0...grid_size).each { |j| possible_positions << [i,j] } }

        #get a random set of coordinates to place mines at
        num_mines.times do
            random_position = possible_positions.sample
            mine_positions << random_position
            possible_positions.delete(random_position)
        end

        mine_positions
    end

    

    def render
        puts "  #{[*0...@grid.count].join(" ")}"

        (0...@grid.count).each do |i|
            row = @grid[i].map {|tile| tile.face}.join(" ")
            puts "#{i} #{row}"
        end
    end
end

b = Board.new(9)
b.render
require_relative "tile.rb"
require "colorize"

class Board
    attr_reader :grid

    def initialize(grid_size, num_mines = 10)
        @grid = []
        @mine_positions = get_mine_positions(grid_size, num_mines)
        mine_neighbors = get_mine_neighbors(@mine_positions, grid_size)

        (0...grid_size).each do |i|
            @grid << []
            (0...grid_size).each do |j|
                val = @mine_positions.include?([i,j]) ? "mine" : mine_neighbors.has_key?([i,j]) ? mine_neighbors[[i,j]] : "clear"
                @grid[i] << Tile.new(val)
            end
        end
    end

    def get_mine_positions(grid_size, num_mines)
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

    def get_mine_neighbors(mine_positions, grid_size)
        mine_neighbors = Hash.new(0)
        
        mine_positions.each_with_index do |pos,ind|
            (-1..1).each do |row|
                (-1..1).each do |col|
                    neighbor = [pos[0]-row, pos[1]-col]
                    next if !neighbor.all? {|pos| pos >= 0 && pos < grid_size}
                    mine_neighbors[neighbor] += 1 if !mine_positions.include?(neighbor)
                end
            end
        end
        mine_neighbors
    end


    def render
        puts "  #{[*0...@grid.count].join(" ")}"

        (0...@grid.count).each do |i|
            row = @grid[i].map {|tile| tile.face}.join(" ")
            puts "#{i} #{row}"
        end
    end

    def reveal(pos)
        row,col = pos
        selected_tile = @grid[row][col]
        #reveal selected 
        
        if selected_tile.reveal(true) == "mine"
            reveal_mines(pos)
            render
            return
        end

        #reveal row
        reveal_row(pos)

        render
    end

    def reveal_row(pos)
    end

    def reveal_mines(selected_pos)
        @mine_positions.each { |pos| @grid[pos[0]][pos[1]].reveal if pos != selected_pos }
    end
end

b = Board.new(9)
b.render
b.reveal([3,4])
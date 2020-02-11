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
        selected_tile.reveal(true)
        if !selected_tile.valid_tile
            reveal_mines(pos)
            return false
        end

        #reveal row
        reveal_neighbors(pos)

        true
    end

    def reveal_neighbors(pos)
        row,col = pos
        start_row = 0
        end_row = @grid.length - 1

        if col_has_mines?(col)
            start_row = closest_left_mine_pos(@grid.transpose,pos.reverse) + 1;
            end_row = closest_right_mine_pos(@grid.transpose,pos.reverse) - 1;
        end

        (start_row..end_row).each do |new_row|
            #next if pos == [new_row,col]
            reveal_row([new_row,col])
        end

    end

    def reveal_row(pos)
        row,col = pos
        grid_size = @grid.count
        start_col = 0
        end_col = grid_size-1

        if row_has_mines?(row)
            start_col = closest_left_mine_pos(@grid,pos) + 1;
            end_col = closest_right_mine_pos(@grid,pos) - 1;
        end

        (start_col..end_col).each do |new_col|
            #next if pos == [row,new_col]
            new_tile = @grid[row][new_col]
            new_tile.reveal
        end
    end

    def closest_left_mine_pos(grid,pos)
        row,col = pos

        if col > 0
            (col-1).downto(0).each do |new_col|
                new_tile = grid[row][new_col]
                return new_col if !new_tile.valid_tile
            end
        end

        return -1
    end

    def closest_right_mine_pos(grid,pos)
        row,col = pos
        grid_size = grid.count

        if col < @grid.count-1
            ((col+1)...grid_size).each do |new_col|
                new_tile = grid[row][new_col]
                return new_col if !new_tile.valid_tile
            end
        end

        return grid_size-1
    end

    def row_has_mines?(row)
        @mine_positions.any? {|pos| pos[0] == (row)}
    end

    def col_has_mines?(col)
        @mine_positions.any? {|pos| pos[1] == (col)}
    end

    def reveal_mines(selected_pos)
        @mine_positions.each { |pos| @grid[pos[0]][pos[1]].reveal if pos != selected_pos }
    end
end

b = Board.new(9)
b.reveal([3,4])
#b.reveal_mines([3,4])
b.render
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

    def valid_pos?(pos)
        row,col = pos
        return false if row < 0 || row > @grid.length-1 || col < 0 || col > @grid.length-1
        true
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
        reveal_neighbors(pos) if !selected_tile.value.is_a? Integer

        true
    end

    def flag(pos)
        row,col = pos
        selected_tile = @grid[row][col]

        if !selected_tile.revealed?
            selected_tile.flag    
        end
    end

    def reveal_neighbors(pos)
        row,col = pos
        start_row = closest_left_marked_pos(@grid.transpose,pos.reverse);
        end_row = closest_right_marked_pos(@grid.transpose,pos.reverse);

        (start_row..end_row).each { |new_row| reveal_row([new_row,col]) }
    end

    def reveal_row(pos)
        row,col = pos
        grid_size = @grid.count
        selected_tile = @grid[row][col]
        selected_tile.reveal if selected_tile.valid_tile

        if !selected_tile.value.is_a? Integer
            start_col = closest_left_marked_pos(@grid,pos);
            end_col = closest_right_marked_pos(@grid,pos);

            (start_col..end_col).each do |new_col|

                new_tile = @grid[row][new_col]
                new_tile.reveal
            end
        end
    end

    def closest_left_marked_pos(grid,pos)
        row,col = pos

        if col > 0
            (col-1).downto(0).each do |new_col|
                new_tile = grid[row][new_col]
                return new_col if (!new_tile.valid_tile) || (new_tile.value.is_a? Integer)
            end
        end

        return 0
    end

    def closest_right_marked_pos(grid,pos)
        row,col = pos
        grid_size = grid.count

        if col < @grid.count-1
            ((col+1)...grid_size).each do |new_col|
                new_tile = grid[row][new_col]
                return new_col if (!new_tile.valid_tile) || (new_tile.value.is_a? Integer)
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

    def reveal_mines(selected_pos=nil)
        @mine_positions.each { |pos| @grid[pos[0]][pos[1]].reveal if pos != selected_pos }
    end

    def all_clears_revealed?
        @grid.each do |row|
            clear_tiles = row.select { |tile| tile.valid_tile }
            return false if !clear_tiles.all? { |tile| tile.revealed? }
        end

        true
    end

    def any_mines_revealed?
        @mine_positions.each do |pos|
            tile = @grid[pos[0]][pos[1]]
            return true if tile.revealed? && !tile.valid_tile
        end

        false
    end

    # used to cheat
    def clear
        @grid.each do |row|
            clear_tiles = row.select { |tile| tile.valid_tile }
            clear_tiles.each {|tile| tile.reveal}
        end
    end
end
#!/usr/bin/env ruby

method "rand"

# This function simply prints the grid given the grid array, the lentgh and the height
def print_grid ( grid, gridl, gridh )

    # Example Grid Map:

    # l →
    # 00 01 02 03 04 05 06 07 h ↓
    # 08 09 10 11 12 13 14 15 
    # 16 17 18 19 20 21 22 23 
    # 24 25 26 27 28 29 30 31 

    # Printing the grid
    h = 0
    i = 0
    while h < gridh
        
        l = 0
        while l < gridl
            print grid[i]
            l = l+1
            i = i+1
        end
        puts ""
        h = h+1
    end
end

# Seeds the first generation of the given the array
def generation_init ( grid, gridl, gridh )
        # TODO: read this data from an external file
        # For the moment will be a random

        alives = rand((gridl*gridh)/6)+1 # Let's generate some random alive cells based on the grid size
        i = 0
        while i <= alives
            value = rand(2)
            if value == 0
                value = "."
            end
            if value == 1
                value = "*"
                alives = alives - 1
            end

            grid[rand((grid.length)-1)] = value

        end

end

# Checks the borders, returns and array with the found border, if empty there is no border around
# t = top, b = bottom, l = left, r = right
# EG: boerd = "tb" means that the cell is located in the top right corner"
def border ( cellcont, gridl )

    # cellcont = cell content, what the cell contains, not its index
    border = Array.new()

    # Row check
    row = cellcont / gridl
    if row == 0
        border << "t"
    end
    if row == gridl-1
        border << "b"
    end

    # Column check
    col = cellcont % gridl
    if col == 0
        border << "l"
    end
    if col == gridl-1
        border << "r"
    end

    return border

end

# Elaborates the array given the array itself and the length of the row
def next_gen ( grid, gridl )

    # We clone the gird that it will be returned because in the rules it's specified that
    # the edit must appear from the next generation
    newgrid = grid

    i = 0               # i is the cell that we are checking
    while i <= grid.length

        alives = 0      # how many alive cells around
        dead = 0        # how many dead cells around

        borders = border i, gridl

        # Right
        if ! borders.include?("r")
            cell = i+1 # cell that must be checked
            #puts "Checking cell on the Right: #{cell}" #DEBUG
            #puts "This cell is #{grid[cell]}" #DEBUG
            if grid[cell] == "*" and cell > 0
                alives = alives +1
                #puts "This cell is alive: #{grid[cell]}" #DEBUG
            else
                dead = dead + 1
            end
        end

        # Left
        if ! borders.include?("l")
            cell = i-1
            #puts "Checking cell on the Left: #{cell}" #DEBUG
            #puts "This cell is #{grid[cell]}" #DEBUG
            if grid[cell] == "*" and cell > 0
                alives = alives +1
                #puts "This cell is alive: #{grid[cell]}" #DEBUG
            else
                dead = dead + 1
            end
        end

        # Top
        if ! borders.include?("t")
            cell = i-gridl
            #puts "Checking cell Top: #{cell}" #DEBUG
            #puts "This cell is #{grid[cell]}" #DEBUG
            if grid[cell] == "*" and cell > 0
                alives = alives +1
                #puts "This cell is alive: #{grid[cell]}" #DEBUG
            else
                dead = dead + 1
            end
        end

        # Bottom
        if ! borders.include?("b")
            cell = i+gridl
            #puts "Checking cell Bottom: #{cell}" #DEBUG
            #puts "This cell is #{grid[cell]}" #DEBUG
            if grid[cell] == "*" and cell > 0
                alives = alives +1
                #puts "This cell is alive: #{grid[cell]}" #DEBUG
            else
                dead = dead + 1
            end
        end

        # Top-left
        if ! borders.include?("t") and ! borders.include?("l")
            cell = i-(gridl+1)
            #puts "Checking cell Top-left: #{cell}" #DEBUG
            #puts "This cell is #{grid[cell]}" #DEBUG
            if grid[cell] == "*" and cell > 0
                alives = alives +1
                #puts "This cell is alive: #{grid[cell]}" #DEBUG
            else
                dead = dead + 1
            end
        end

        # Top-right
        if ! borders.include?("t") and ! borders.include?("r")
            cell = i-(gridl-1)
            #puts "Checking cell Top-right: #{cell}" #DEBUG
            #puts "This cell is #{grid[cell]}" #DEBUG
            if grid[cell] == "*" and cell > 0
                alives = alives +1
                #puts "This cell is alive: #{grid[cell]}" #DEBUG
            else
                dead = dead + 1
            end
        end

        # Bottom-left
        if ! borders.include?("b") and ! borders.include?("l")
            cell = i+(gridl-1)
            #puts "Checking cell Bottom-left: #{cell}" #DEBUG
            #puts "This cell is #{grid[cell]}" #DEBUG
            if grid[cell] == "*" and cell > 0
                alives = alives +1
                #puts "This cell is alive: #{grid[cell]}" #DEBUG
            else
                dead = dead + 1
            end
        end

        # Bottom-right
        if ! borders.include?("b") and ! borders.include?("r")
            cell = i+(gridl+1)
            #puts "Checking cell Bottom-right: #{cell}" #DEBUG
            #puts "This cell is #{grid[cell]}" #DEBUG
            if grid[cell] == "*" and cell > 0
                alives = alives +1
            else
                dead = dead + 1
            end
        end

        # Check for life and death
        # Rules:        
        
        #DEBUG
        #puts ""
        #puts "Checking cell #{i}, is: #{grid[i]}"
        #puts "We got #{alives} alives and #{dead} dead cells around it."
        #DEBUG - END
        if grid[i] == "*"
            #puts "gird[#{i}] instead, is: #{grid[i]}" #DEBUG
            if alives >= 2 and alives <= 3
                # 2. Any live cell with two or three live neighbours lives on to the next generation.
                #puts "2. Any live cell with two or three live neighbours lives on to the next generation." #DEBUG
                #puts "gird[#{i}] instead, is: #{grid[i]}" #DEBUG
                newgrid[i] = "*"
                #puts "newgrid[#{i}] = #{newgrid[i]}" #DEBUG
                #puts "gird[#{i}] instead, is: #{grid[i]}" #DEBUG
            else
                # 1. Any live cell with fewer than two live neighbours dies.
                # 3. Any live cell with more than three live neighbours dies.
                #puts "1. Any live cell with fewer than two live neighbours dies." #DEBUG
                #puts "3. Any live cell with more than three live neighbours dies." #DEBUG
                newgrid[i] = "."
                #puts "newgrid[#{i}] = #{newgrid[i]}" #DEBUG
                #puts "gird[#{i}] instead, is: #{grid[i]}" #DEBUG
            end
        end

        if grid[i] == "." and alives == 3
            # 4. Any dead cell with exactly three live neighbours becomes a live cell.
            #puts "4. Any dead cell with exactly three live neighbours becomes a live cell." #DEBUG
            newgrid[i] = "*"
            #puts "newgrid[#{i}] = #{newgrid[i]}" #DEBUG
            #puts "gird[#{i}] instead, is: #{grid[i]}" #DEBUG
        end

        #DEBUG
        #puts "From the next generation cell ##{i} will be #{newgrid[i]}"
        #puts ""
        #DEBUG - END

        #DEBUG
        #puts "Cells alive around = #{alives}"
        #puts "Cells dead around = #{dead}"
        #print "Press any key to continue\r"
        #gets

        i = i+1

    end

    return newgrid

end

puts "== Welcome to the Game of Life =="
puts ""

# TODO: read these variables from a text file
gridl = 128           # grid length (horizontal entries)
gridh = 128           # grid heigth (vertical entries)
start_gen = 1       # Starting generation

current_gen = 1     # We always start from generation 1
end_gen = 100        # The last generation

grid = Array.new(gridl*gridh, ".") # Initializing a blank (.) array
generation_init grid, gridl, gridh


while current_gen <= end_gen

    # We want to calculate all the generations, but print will start from the requested one
    if current_gen >= start_gen

        puts "Generation #{current_gen}:"
        puts "#{gridh}x#{gridl}"
        print_grid grid, gridl, gridh
        puts ""
        sleep(0.5)

    end
    newgrid = next_gen grid, gridl
    # TODO-maybe: some implementation ideas
    # if current_gen > 1 and ! newgrid.include?("*")
    #     puts "All cells are dead, sorry"
    #     exit
    # end
    # if current_gen > 1 and newgrid == grid
    #     puts "We have found a balance, this cells will live forever but they will not create new ones"
    #     exit
    # end
    grid = newgrid
    current_gen = current_gen + 1

end
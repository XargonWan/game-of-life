#!/usr/bin/env ruby

method "rand"
require "yaml"

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
def generation_init ( gridl, gridh )

        # Initializing a basic, dot filled (.) array
        gen_grid = Array.new( gridl*gridh, "." )

        # Let's generate some random alive cells based on the grid size
        alives = rand((gridl*gridh)/6)+1
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

            gen_grid[rand((gen_grid.length)-1)] = value

        end

        return gen_grid

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
            if grid[cell] == "*"
                alives = alives +1
            else
                dead = dead + 1
            end
        end

        # Left
        if ! borders.include?("l")
            cell = i-1
            if cell > 0 and grid[cell] == "*"
                alives = alives +1
            else
                dead = dead + 1
            end
        end

        # Top
        if ! borders.include?("t")
            cell = i-gridl
            if grid[cell] == "*" and cell > 0
                alives = alives +1
            else
                dead = dead + 1
            end
        end

        # Bottom
        if ! borders.include?("b")
            cell = i+gridl
            if grid[cell] == "*" and cell > 0
                alives = alives +1
            else
                dead = dead + 1
            end
        end

        # Top-left
        if ! borders.include?("t") and ! borders.include?("l")
            cell = i-(gridl+1)
            if grid[cell] == "*" and cell > 0
                alives = alives +1
            else
                dead = dead + 1
            end
        end

        # Top-right
        if ! borders.include?("t") and ! borders.include?("r")
            cell = i-(gridl-1)
            if grid[cell] == "*" and cell > 0
                alives = alives +1
            else
                dead = dead + 1
            end
        end

        # Bottom-left
        if ! borders.include?("b") and ! borders.include?("l")
            cell = i+(gridl-1)
            if grid[cell] == "*" and cell > 0
                alives = alives +1
            else
                dead = dead + 1
            end
        end

        # Bottom-right
        if ! borders.include?("b") and ! borders.include?("r")
            cell = i+(gridl+1)
            if grid[cell] == "*" and cell > 0
                alives = alives +1
            else
                dead = dead + 1
            end
        end

        # Check for life and death
        # Rules:        

        if grid[i] == "*"
            if alives >= 2 and alives <= 3
                # 2. Any live cell with two or three live neighbours lives on to the next generation.
                newgrid[i] = "*"
            else
                # 1. Any live cell with fewer than two live neighbours dies.
                # 3. Any live cell with more than three live neighbours dies.
                newgrid[i] = "."
            end
        end

        if grid[i] == "." and alives == 3
            # 4. Any dead cell with exactly three live neighbours becomes a live cell.
            newgrid[i] = "*"
        end

        i = i+1

    end

    return newgrid

end

def write_conf ( grid, gridl, gridh, start_gen, end_gen, delay )

    ymldump = {
        'title' => 'Game of Life',
        'config' => [
            {'grid_length'         => "#{gridl}"},
            {'grid_heigth'         => "#{gridh}"},
            {'starting_generation' => "#{start_gen}"},
            {'final_generation'    => "#{end_gen}"},
            {'delay'               => "#{delay}"}
        ],
        'grid' => "#{grid}"
    }

    File.open($confloc, "w") do |file|
         file.puts YAML::dump( ymldump )
    end

end

puts "== Welcome to the Game of Life ==\n\n"

# If the external config is disabled (hardcoded) then will initialize the default variables
gridl = 8                                   # grid length (horizontal entries)
gridh = 4                                   # grid heigth (vertical entries)
start_gen = 1                               # Starting generation
end_gen = 100                               # The last generation
delay = 0.5                                 # Delay for the new generation in milliseconds

grid = generation_init gridl, gridh          # Initializing the actual grid

$confloc = "config.yml"   # config file location
ext_config = true       # if true it will load/write the configs from the external config file, else it will use harcoded configs

# Managing the config/file
if ext_config == true

    if File.exists? ($confloc)

        puts "Loading data from #{$confloc}\n"

        ymldump = YAML.load_file($confloc)

        # YAML delivers a string, so int must be coverted into int and [0...3] + .to_i must be put
        # for the grid, I get a string that I am converting it into an array again with split
        gridl = ymldump['config'][0]['grid_length'].to_i
        gridh = ymldump['config'][1]['grid_heigth'].to_i
        start_gen = ymldump['config'][2]['starting_generation'].to_i
        end_gen = ymldump['config'][3]['final_generation'].to_i
        delay = ymldump['config'][4]['delay'].to_f
        grid = ymldump['grid'].tr('[]", ','').split('')

        puts "Data loaded!\n\n"

        # Checking if the given grid got the right size
        if grid.length != gridl*gridh
            puts "The given grid from the config file's size is not matching the given grid length and height, generating a new one.\n\n"
            grid = generation_init gridl, gridh
        end
 
    else
        
        # We have to initialize the config file
        puts "Config file #{$confloc} not found, intializing it."
        write_conf grid, gridl, gridh, start_gen, end_gen, delay

    end

end

current_gen = 1     # We always start to calculate from generation 1

while current_gen <= end_gen

    # We want to calculate all the generations, but print will start from the requested one
    if current_gen >= start_gen

        puts "Generation #{current_gen}:"
        puts "#{gridh}x#{gridl}"
        print_grid grid, gridl, gridh
        puts ""
        sleep(delay)

    end
    newgrid = next_gen grid, gridl
    if current_gen > 1 and ! newgrid.include?("*")
        puts "All cells are dead, sorry"
        exit
    end
    # TODO: some future implementation ideas
    # if current_gen > 1 and newgrid == grid
    #     puts "We have found a balance, this cells will live forever but they will not create new ones"
    #     exit
    # end
    grid = newgrid
    current_gen = current_gen + 1

end

if ext_config == true
    puts "Do you want to save the current data to #{$confloc}? [Y/n]"
    answer = gets.chomp   # gets gets the newline, chomp removes it
    if answer.downcase != "n"
        write_conf grid, gridl, gridh, start_gen, end_gen, delay
        puts "Data correctly saved!"
    end
end

puts "Program terminarted."
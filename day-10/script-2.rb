NORTH_LETTERS = ['S', '│', '└', '┘']
SOUTH_LETTERS = ['S', '│', '┐', '┌']
WEST_LETTERS  = ['S', '─', '┐', '┘']
EAST_LETTERS  = ['S', '─', '└', '┌']

def print_tiles(tiles)
  tiles.each do |tile_line|
    tile_line.each do |tile|
      if tile[:out]
        print "\e[30m0\e[0m" # 0 in black
      elsif tile[:in]
        print "\e[46m1\e[0m" # 1 in background red
      else
        print tile[:pipe]
      end
    end
    puts "\n"
  end
end

def navigate(tiles)
  start_tile = tiles.flatten.detect { |tile| tile[:pipe] == 'S' }
  start_tile[:value] = 0

  tiles_queue = [start_tile]

  while tiles_queue.any?
    tile = tiles_queue.shift

    neighbor_tiles = []
    neighbor_tiles << tiles[tile[:i] + 1][tile[:j]    ] if SOUTH_LETTERS.include?(tile[:pipe]) && NORTH_LETTERS.include?(tiles[tile[:i] + 1][tile[:j]    ][:pipe]) && tile[:i] + 1 < tiles.size       # Test bottom position
    neighbor_tiles << tiles[tile[:i] - 1][tile[:j]    ] if NORTH_LETTERS.include?(tile[:pipe]) && SOUTH_LETTERS.include?(tiles[tile[:i] - 1][tile[:j]    ][:pipe]) && tile[:i] - 1 >= 0                # Test top position
    neighbor_tiles << tiles[tile[:i]    ][tile[:j] + 1] if EAST_LETTERS.include?(tile[:pipe])  && WEST_LETTERS.include?( tiles[tile[:i]    ][tile[:j] + 1][:pipe]) && tile[:j] + 1 < tiles.first.size # Test right position
    neighbor_tiles << tiles[tile[:i]    ][tile[:j] - 1] if WEST_LETTERS.include?(tile[:pipe])  && EAST_LETTERS.include?( tiles[tile[:i]    ][tile[:j] - 1][:pipe]) && tile[:j] - 1 >= 0                # Test left position

    # Keep only pipes not already navigated
    neighbor_tiles = neighbor_tiles.select { |neighbor_tile| neighbor_tile[:value] == -1 || neighbor_tile[:value] > tile[:value] }

    # Attribute value to neighbords and put them at start of queue (LIFO)
    neighbor_tiles.each do |neighbor_tile|
      new_value             = tile[:value] + 1
      neighbor_tile[:value] = new_value
      tiles_queue.unshift(neighbor_tile)
    end
  end
end

def flag_external_tiles(tiles)
  tiles_queue = []
  tiles_queue += tiles.first + tiles.last
  tiles_queue += tiles.collect { |tile_line| tile_line.first } + tiles.collect { |tile_line| tile_line.last }

  tiles_queue = tiles_queue.select { |tile| tile[:value] == -1 }

  pp tiles_queue

  while tiles_queue.any?
    tile = tiles_queue.shift

    tile[:out] = true

    neighbor_tiles = []
    neighbor_tiles << tiles[tile[:i] + 1][tile[:j]    ] if tile[:i] + 1 < tiles.size       # Test bottom position
    neighbor_tiles << tiles[tile[:i] - 1][tile[:j]    ] if tile[:i] - 1 >= 0               # Test top position
    neighbor_tiles << tiles[tile[:i]    ][tile[:j] + 1] if tile[:j] + 1 < tiles.first.size # Test right position
    neighbor_tiles << tiles[tile[:i]    ][tile[:j] - 1] if tile[:j] - 1 >= 0               # Test left position

    # Keep only pipes not already navigated
    neighbor_tiles = neighbor_tiles.select { |neighbor_tile| !neighbor_tile[:out] && neighbor_tile[:value] == -1 }

    tiles_queue = neighbor_tiles + tiles_queue
  end

  pp tiles_queue
end

def flag_internal_tiles(tiles)
  tiles.each do |tile_line|
    tile_line.each do |tile|
      tile[:in] = true if tile[:value] == -1 && !tile[:out]
    end
  end
end

# Open file and change chars for better lisibility
lines = File.read('./tiles.txt')
            .gsub('|', '│').gsub('-', '─').gsub('L', '└').gsub('J', '┘').gsub('7', '┐').gsub('F', '┌')
            .split("\n")

# Initialize important values for tiles
tiles = lines.collect.with_index do |tile_line, i|
  tile_line.chars.collect.with_index do |pipe, j|
    {
      :pipe  => pipe,
      :value => -1,
      :i     => i,
      :j     => j,
      :out   => false
    }
  end
end

# Main algo
navigate(tiles)

# Detect external areas
flag_external_tiles(tiles)

# What really interest us!
flag_internal_tiles(tiles)

print_tiles(tiles)

puts tiles.flatten.collect { |pipe| pipe[:value] }.max

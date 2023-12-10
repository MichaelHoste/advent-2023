NORTH_LETTERS = ['S', '│', '└', '┘']
SOUTH_LETTERS = ['S', '│', '┐', '┌']
WEST_LETTERS  = ['S', '─', '┐', '┘']
EAST_LETTERS  = ['S', '─', '└', '┌']

def print_tiles(tiles)
  tiles.each do |tile_line|
    tile_line.each do |tile|
      print tile[:pipe]
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
    neighbor_tiles << tiles[tile[:i] - 1][tile[:j]    ] if NORTH_LETTERS.include?(tile[:pipe]) && SOUTH_LETTERS.include?(tiles[tile[:i] - 1][tile[:j]    ][:pipe]) && tile[:i] - 1 >= 0               # Test top position
    neighbor_tiles << tiles[tile[:i]    ][tile[:j] + 1] if EAST_LETTERS.include?(tile[:pipe])  && WEST_LETTERS.include?( tiles[tile[:i]    ][tile[:j] + 1][:pipe]) && tile[:j] + 1 < tiles.first.size # Test right position
    neighbor_tiles << tiles[tile[:i]    ][tile[:j] - 1] if WEST_LETTERS.include?(tile[:pipe])  && EAST_LETTERS.include?( tiles[tile[:i]    ][tile[:j] - 1][:pipe]) && tile[:j] - 1 >= 0               # Test left position

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
      :j     => j
    }
  end
end

# Main algo
navigate(tiles)

print_tiles(tiles)

puts tiles.flatten.collect { |pipe| pipe[:value] }.max

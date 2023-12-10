NORTH_LETTERS = ['S', '|', 'L', 'J']
SOUTH_LETTERS = ['S', '|', '7', 'F']
WEST_LETTERS  = ['S', '-', '7', 'J']
EAST_LETTERS  = ['S', '-', 'L', 'F']

def navigate(tiles, start_pipe)
  pipes_queue = [start_pipe]

  while pipes_queue.any?
    pipe = pipes_queue.shift

    neighbor_pipes = []
    neighbor_pipes << tiles[pipe[:i] + 1][pipe[:j]    ] if SOUTH_LETTERS.include?(pipe[:pipe]) && NORTH_LETTERS.include?(tiles[pipe[:i] + 1][pipe[:j]    ][:pipe]) && pipe[:i] + 1 < tiles.size       # Test bottom position
    neighbor_pipes << tiles[pipe[:i] - 1][pipe[:j]    ] if NORTH_LETTERS.include?(pipe[:pipe]) && SOUTH_LETTERS.include?(tiles[pipe[:i] - 1][pipe[:j]    ][:pipe]) && pipe[:i] - 1 > 0                # Test top position
    neighbor_pipes << tiles[pipe[:i]    ][pipe[:j] + 1] if EAST_LETTERS.include?(pipe[:pipe])  && WEST_LETTERS.include?( tiles[pipe[:i]    ][pipe[:j] + 1][:pipe]) && pipe[:j] + 1 < tiles.first.size # Test right position
    neighbor_pipes << tiles[pipe[:i]    ][pipe[:j] - 1] if WEST_LETTERS.include?(pipe[:pipe])  && EAST_LETTERS.include?( tiles[pipe[:i]    ][pipe[:j] - 1][:pipe]) && pipe[:j] - 1 > 0                # Test left position

    # Keep only pipes not already navigated
    neighbor_pipes = neighbor_pipes.select { |neighbor_pipe| neighbor_pipe[:value] == -1 || neighbor_pipe[:value] > pipe[:value] }

    # Attribute value to neighbords and put them at start of queue (LIFO)
    neighbor_pipes.each do |neighbor_pipe|
      new_value             = pipe[:value] + 1
      neighbor_pipe[:value] = new_value
      pipes_queue.unshift(neighbor_pipe)
    end
  end
end

lines = File.read('./tiles.txt').split("\n")

tiles = lines.collect.with_index do |line, i|
  line.chars.collect.with_index do |pipe, j|
    {
      :pipe  => pipe,
      :value => -1,
      :i     => i,
      :j     => j
    }
  end
end

start_pipe = tiles.flatten.detect { |tile| tile[:pipe] == 'S' }
start_pipe[:value] = 0

navigate(tiles, start_pipe)

puts tiles.flatten.collect { |pipe| pipe[:value] }.max

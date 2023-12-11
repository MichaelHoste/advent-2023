lines      = File.read('./network.txt').split("\n")
directions = lines.first.chars.to_a * 1000

network = lines.drop(2).collect do |line|
  entry     = line.split(' = ').first
  out_left  = line.split(' = ').last.split(', ').first.gsub('(', '')
  out_right = line.split(' = ').last.split(', ').last.gsub(')', '')

  [
    entry,
    { 'L' => out_left, 'R' => out_right}
  ]
end.to_h

starting_nodes = network.keys.select { |key| key.end_with?('A') }
nodes          = starting_nodes.collect { |node| node } # copy

responses = starting_nodes.collect do |node|
  i = 0

  directions.each do |direction|
    i += 1
    node = network[node][direction]
    break if node.end_with?('Z')
  end

  i
end

puts responses.reduce(&:lcm)

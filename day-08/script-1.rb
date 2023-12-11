lines      = File.read('./network.txt').split("\n")
directions = lines.first.chars.to_a * 100

network = lines.drop(2).collect do |line|
  entry     = line.split(' = ').first
  out_left  = line.split(' = ').last.split(', ').first.gsub('(', '')
  out_right = line.split(' = ').last.split(', ').last.gsub(')', '')

  [
    entry,
    { 'L' => out_left, 'R' => out_right}
  ]
end.to_h

i    = 0
node = 'AAA'

directions.each do |direction|
  i += 1
  node = network[node][direction]
  break if node == 'ZZZ'
end

puts i

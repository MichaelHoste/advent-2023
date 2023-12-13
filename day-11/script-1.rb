def expand_universe(universe)
  expand_universe_columns(
    expand_universe_lines(
      universe
    )
  )
end

def expand_universe_lines(universe)
  (0..universe.size-1).collect do |i| # each line
    if universe[i].all? { |char| char == '.' }
      [universe[i]] * 2
    else
      [universe[i]]
    end
  end.flatten(1)
end

def expand_universe_columns(universe)
  expand_universe_lines(universe.transpose).transpose
end

def number_galaxies(universe)
  count = 0

  universe.collect.with_index do |universe_line, i|
    universe_line.collect.with_index do |space, j|
      space == '#' ? "#{count+=1}" : space
    end
  end
end

def create_galaxies_hash(universe)
  galaxies_hash = {}

  universe.each_with_index do |universe_line, i|
    universe_line.each_with_index do |space, j|
      if space != '.'
        galaxies_hash[space.to_i] = { :i => i, :j => j }
      end
    end
  end

  galaxies_hash
end

universe = File.read('./galaxies.txt').split("\n").collect do |line|
  line.chars
end

pp universe
puts "---"
pp universe = expand_universe(universe)
puts "---"
pp universe = number_galaxies(universe)
puts "---"
pp galaxies_hash = create_galaxies_hash(universe)
puts "---"

last_galaxy_number = galaxies_hash.keys.last

total = (1..last_galaxy_number-1).sum do |start_galaxy|
  (start_galaxy+1..last_galaxy_number).sum do |end_galaxy|
    a = (galaxies_hash[start_galaxy][:i] - galaxies_hash[end_galaxy][:i]).abs
    b = (galaxies_hash[start_galaxy][:j] - galaxies_hash[end_galaxy][:j]).abs
    a + b
  end
end

puts total

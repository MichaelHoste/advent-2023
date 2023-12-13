MULTIPY = 5

def possible_positions(line, number)
  positions = []

  line.split('').each_with_index do |letter, index|
    free_place             = line[index...index+number].gsub('?', '#') == '#'*number
    previous_one_not_taken = index-1 < 0 || line[index-1].to_s != '#'
    next_one_not_taken     = index+number > line.size-1 || line[index+number].to_s != '#'

    if free_place && next_one_not_taken && previous_one_not_taken
      positions << index
    end

    break if letter == '#'
  end

  positions
end

# This method should not be needed, it's a last-minute fix to not include some invalid paths
# that should have been rejected before but are not (why!?)
def path_ok?(path, groups)
  path_groups = []
  increment   = 0

  path.chars.each do |char|
    if char == '#'
      increment += 1
    else
      path_groups << increment if increment > 0
      increment = 0
    end
  end

  path_groups << increment if increment > 0

  groups == path_groups
end

def arrangements(spring, hash, initial_groups)
  if spring[:groups].any?
    if hash[[spring[:line], spring[:groups]]]
      return hash[[spring[:line], spring[:groups]]]
    else
      number        = spring[:groups].first
      start_indexes = possible_positions(spring[:line], number)

      total = start_indexes.collect do |start_index|
        start            = (spring[:path].size - spring[:line].size) + start_index
        path             = spring[:path]
        updated_path     = path[0...start].to_s + ('#' * number) + path[start+number..-1]
        remaining_line   = path[start+number+1..-1].to_s
        remaining_groups = spring[:groups].drop(1)

        arrangements({
          :path   => updated_path,
          :line   => remaining_line,
          :groups => remaining_groups
        }, hash, initial_groups)
      end.sum

      hash[[spring[:line], spring[:groups]]] = total
    end
  else
    if path_ok?(spring[:path], initial_groups) # Should not be needed if the above algos were 100% correct but... who cares? 😁
      1
    else
      0
    end
  end
end

springs = File.read('./springs.txt').split("\n").collect do |line|
  {
    :path   => ([line.split(' ').first]*MULTIPY).join('?'),
    :line   => ([line.split(' ').first]*MULTIPY).join('?'),
    :groups => line.split(' ').last.split(',').collect(&:to_i)*MULTIPY
  }
end

sizes = springs.collect.with_index do |spring, i|
  size = arrangements(spring, {}, spring[:groups])

  puts "#{i} - #{size}"
  size
end

puts sizes.sum


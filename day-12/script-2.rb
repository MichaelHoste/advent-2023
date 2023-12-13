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

def arrangements(spring)
  if spring[:groups].any?
    number        = spring[:groups].first
    start_indexes = possible_positions(spring[:line], number)

    start_indexes.collect do |start_index|
      start          = (spring[:path].size - spring[:line].size) + start_index
      path           = spring[:path]
      updated_path   = path[0...start].to_s + ('#' * number) + path[start+number..-1]
      remaining_line = path[start+number+1..-1].to_s
      updated_groups = spring[:groups].drop(1)

      if remaining_line.count('?') + remaining_line.count('#') >= updated_groups.sum #+ [updated_groups.size - 1, 0].max
        arrangements({
          :path   => updated_path,
          :line   => remaining_line, # Create substring with empty space + the remaining )
          :groups => updated_groups
        })
      else
        []
      end
    end.flatten
  else
    [spring]
  end
end

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


springs = File.read('./springs.txt').split("\n").collect do |line|
  {
    :path   => ([line.split(' ').first]*MULTIPY).join('?'),
    :line   => ([line.split(' ').first]*MULTIPY).join('?'),
    :groups => line.split(' ').last.split(',').collect(&:to_i)*MULTIPY
  }
end


sizes = springs.collect.with_index do |spring, i|
  size = arrangements(spring).flatten
                             .select { |spring| spring[:groups].none? }
                             .uniq { |spring| spring[:path] }
                             .select { |spring| path_ok?(spring[:path], springs[i][:groups]) }
                             .size
  puts "#{i} - #{size}" if MULTIPY > 1
  size
end

puts sizes.sum

# pp possible_positions('#?#????????.?#', 4)
# pp possible_positions('####???????.?#.', 1)


# pp springs[40]
# pp arrangements(springs[1])


# too low: 709232705819
#          708115787581
#          712617224806.0437

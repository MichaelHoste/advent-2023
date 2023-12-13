def valid_indexes?(pattern, index_1, index_2)
  valid = true

  while index_1 >= 0 && index_2 < pattern.size
    if pattern[index_1] != pattern[index_2]
      valid = false
    end

    index_1 = index_1 - 1
    index_2 = index_2 + 1
  end

  return valid
end

def symmetry_line_index(pattern)
  lines = pattern # Better naming here

  candidate_line_indexes = lines.collect.with_index do |line, index|
    if index + 1 < lines.size && line.join == lines[index+1].join
      [index, index+1]
    end
  end.compact

  candidate_line_indexes.select do |line_index_1, line_index_2|
    valid_indexes?(pattern, line_index_1, line_index_2)
  end
end

patterns = File.read('./patterns.txt').split("\n\n").collect do |pattern|
  pattern.split("\n").collect do |pattern_line|
    pattern_line.chars
  end
end

total = patterns.sum do |pattern|
  vertical_symmetry_indexes   = symmetry_line_index(pattern)
  horizontal_symmetry_indexes = symmetry_line_index(pattern.transpose)

  if (vertical_symmetry_indexes + horizontal_symmetry_indexes).size > 1
    puts "ERROR"
    pp vertical_symmetry_indexes
    pp horizontal_symmetry_indexes
    0
  else
    if horizontal_symmetry_indexes.flatten.any?
      horizontal_symmetry_indexes.flatten[0]+1
    elsif vertical_symmetry_indexes.flatten.any?
      (vertical_symmetry_indexes.flatten[0]+1) * 100
    end
  end
end

puts total


# pp symmetry_line_index(patterns[0])
# pp symmetry_line_index(patterns[0].transpose)


# pp symmetry_line_index(patterns[1])
# pp symmetry_line_index(patterns[1].transpose)

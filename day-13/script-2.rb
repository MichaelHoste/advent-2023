def valid_indexes?(pattern, index_1, index_2)
  valid = true

  while index_1 >= 0 && index_2 < pattern.size
    valid = false if pattern[index_1] != pattern[index_2]

    index_1 = index_1 - 1
    index_2 = index_2 + 1
  end

  return valid
end

def symmetry_line_indexes(pattern)
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

def fixed_pattern(pattern)
  old_vertical_symmetry_indexes   = symmetry_line_indexes(pattern).flatten
  old_horizontal_symmetry_indexes = symmetry_line_indexes(pattern.transpose).flatten

  lines = pattern # Better naming here

  lines.each.with_index do |line, i|
    line.each.with_index do |char, j|
      pattern[i][j] = (char == '.') ? '#' : '.'

      new_vertical_symmetry_indexes   = symmetry_line_indexes(pattern).flatten
      new_horizontal_symmetry_indexes = symmetry_line_indexes(pattern.transpose).flatten

      vertical_condition   = new_vertical_symmetry_indexes.any?   && new_vertical_symmetry_indexes   != old_vertical_symmetry_indexes
      horizontal_condition = new_horizontal_symmetry_indexes.any? && new_horizontal_symmetry_indexes != old_horizontal_symmetry_indexes

      if vertical_condition || horizontal_condition
        return pattern
      else
        pattern[i][j] = char # put back char
      end
    end
  end
end

old_patterns = File.read('./patterns.txt').split("\n\n").collect do |pattern|
  pattern.split("\n").collect do |pattern_line|
    pattern_line.chars
  end
end

new_patterns = Marshal.load(Marshal.dump(old_patterns)) # 🤮

new_patterns = new_patterns.collect do |pattern|
  fixed_pattern(pattern)
end

values = new_patterns.collect.with_index do |pattern, i|
  old_vertical_symmetry_indexes   = symmetry_line_indexes(old_patterns[i])
  old_horizontal_symmetry_indexes = symmetry_line_indexes(old_patterns[i].transpose)

  new_vertical_symmetry_indexes   = symmetry_line_indexes(pattern)
  new_horizontal_symmetry_indexes = symmetry_line_indexes(pattern.transpose)

  horizontal_indexes = new_horizontal_symmetry_indexes - old_horizontal_symmetry_indexes
  vertical_indexes   = new_vertical_symmetry_indexes   - old_vertical_symmetry_indexes

  if horizontal_indexes.flatten.any?
    horizontal_indexes.flatten[0] + 1
  elsif vertical_indexes.flatten.any?
    (vertical_indexes.flatten[0] + 1) * 100
  end
end

puts values.sum


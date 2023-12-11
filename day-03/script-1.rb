def extract_subline(lines, line_index, col_index, digits_number)
  col_size        = lines.first.size
  start_col_index = [col_index - 1, 0].max
  end_col_index   = [col_index + digits_number, col_size].min

  if line_index >= 0 && line_index < lines.size
    lines[line_index][start_col_index..end_col_index]
  else
    ""
  end
end

# Create bounding box around number, and check if special char
def admissible?(lines, line_index, col_index, digits_number)
  [
    extract_subline(lines, line_index - 1, col_index, digits_number),
    extract_subline(lines, line_index,     col_index, digits_number),
    extract_subline(lines, line_index + 1, col_index, digits_number)
  ].join.gsub('.', '').match? /\D/
end

#########

answer = 0

lines = File.read('./engine.txt').split("\n")

lines.each_with_index do |line, line_index|
  line     = line.dup
  col_index = 0

  while line.size > 0
    if line.to_i > 0 # start of a number
      number        = line.to_i
      digits_number = number.to_s.size

      if admissible?(lines, line_index, col_index, digits_number)
        answer = answer + number
      end

      col_index = col_index + digits_number
      line.slice!(0, digits_number) # remove first chars
    else # everything else
      line.slice!(0, 1)
      col_index = col_index + 1
    end
  end
end

puts answer

def slide_north(mirror)
  rotated_mirror = mirror.transpose.collect { |line| line.join }

  rotated_mirror.collect do |line|
    while line != line.gsub('.O', 'O.')
      line.gsub!('.O', 'O.')
    end

    line
  end

  rotated_mirror.collect { |line| line.split('') }.transpose
end

def slide_south(mirror)
  rotated_mirror = mirror.transpose.collect { |line| line.join }

  rotated_mirror.collect do |line|
    while line != line.gsub('O.', '.O')
      line.gsub!('O.', '.O')
    end

    line
  end

  rotated_mirror.collect { |line| line.split('') }.transpose
end

def slide_east(mirror)
  rotated_mirror = mirror.collect { |line| line.join }

  rotated_mirror.collect do |line|
    while line != line.gsub('O.', '.O')
      line.gsub!('O.', '.O')
    end

    line
  end

  rotated_mirror.collect { |line| line.split('') }
end

def slide_west(mirror)
  rotated_mirror = mirror.collect { |line| line.join }

  rotated_mirror.collect do |line|
    while line != line.gsub('.O', 'O.')
      line.gsub!('.O', 'O.')
    end

    line
  end

  rotated_mirror.collect { |line| line.split('') }
end

def find_repeated_sequence_and_start(sequence)
  size  = sequence.size
  array = sequence.collect { |entry| entry.last }.reverse

  current_sequence = []
  start_index      = -1

  (0..size-1).each do |index|
    current_sequence << array[index]

    if current_sequence == array[index+1...index+1+current_sequence.size]
      start_index = index+1
      break
    end
  end

  repeated_sequence = current_sequence.reverse
  array             = array.reverse

  start_index = 0

  array.each_with_index do |cell, i|
    if array[i...i+repeated_sequence.size] == repeated_sequence
      start_index = i
      break
    end
  end

  {
    :start             => start_index,
    :repeated_sequence => repeated_sequence
  }
end

mirror = File.read('./mirror.txt').split("\n").collect do |mirror_line|
  mirror_line.split("").collect do |cell|
    cell
  end
end

total     = 0
new_total = 1

sequence = (1..400).collect do |i|
  total = new_total
  mirror = slide_north(mirror)
  mirror = slide_west(mirror)
  mirror = slide_south(mirror)
  mirror = slide_east(mirror)

  new_total = 0

  mirror.each_with_index do |line, i|
    line.each_with_index do |cell, j|
      new_total +=  mirror.size-i if cell == 'O'
    end
  end

  [i, new_total]
end

values = find_repeated_sequence_and_start(sequence)

index = (1_000_000_000 - values[:start]-1) % values[:repeated_sequence].size
puts values[:repeated_sequence][index]


# 104958 too high
# 104903 too high
# 104788 too low
# 104844 not right
# 104897 not right


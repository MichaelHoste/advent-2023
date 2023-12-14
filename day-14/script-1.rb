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

mirror = File.read('./mirror.txt').split("\n").collect do |mirror_line|
  mirror_line.split("").collect do |cell|
    cell
  end
end

mirror = slide_north(mirror)

total = 0

mirror.each_with_index do |line, i|
  line.each_with_index do |cell, j|
    total +=  mirror.size-i if cell == 'O'
  end
end

pp total

#puts total.sum

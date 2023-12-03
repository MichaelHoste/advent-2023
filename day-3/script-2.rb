def gear_positions(lines)
  gear_positions = []

  lines.each_with_index do |line, line_index|
    line = line.gsub('.', '1')
    positions = line.enum_for(:scan, /\D/).collect { Regexp.last_match.begin(0) }

    gear_positions += positions.collect do |position|
      {
        :i => line_index,
        :j => position
      }
    end
  end

  gear_positions
end

def number_positions(lines)
  number_positions = []

  lines.each_with_index do |line, line_index|
    positions = line.enum_for(:scan, /\d+/).collect { Regexp.last_match.begin(0) }

    number_positions += positions.collect do |position|
      number = line[position..-1].to_i

      {
        :number => number,
        :i      => line_index,
        :j      => position,
        :length => number.to_s.size
      }
    end
  end

  number_positions
end

def numbers_for_gear(gear_position, number_positions)
  number_positions_for_gear = number_positions.select do |number_position|
    gear_i = gear_position[:i]
    gear_j = gear_position[:j]
    num_i  = number_position[:i]
    num_j  = number_position[:j]
    digits = number_position[:length]

    vertical_ok   = ((gear_i - 1)..(gear_i + 1)).include?(num_i)
    horizontal_ok = ((num_j - 1)..(num_j + digits)).include?(gear_j)

    vertical_ok && horizontal_ok
  end

  number_positions_for_gear.collect { |number_position| number_position[:number] }
end

#########

answer = 0

lines = File.read('./engine.txt').split("\n")

gear_positions   = gear_positions(lines)
number_positions = number_positions(lines)

gear_positions.each do |gear_position|
  numbers_for_gear = numbers_for_gear(gear_position, number_positions)

  if numbers_for_gear.size == 2
    answer += numbers_for_gear[0] * numbers_for_gear[1]
  end
end

puts answer

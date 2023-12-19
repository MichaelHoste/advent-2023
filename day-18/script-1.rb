def limits(instructions, direction)
  value = 0

  if direction == :horizontal
    plus  = 'r'
    minus = 'l'
  elsif direction == :vertical
    plus  = 'd'
    minus = 'u'
  end

  values = instructions.collect do |ins|
    if ins[:dir] == minus
      value = value - ins[:distance]
    elsif ins[:dir] == plus
      value = value + ins[:distance]
    end

    value
  end

  {
    :min => values.min,
    :max => values.max,
  }
end

def paint_outside(terrain, i, j)
  positions = [{ :i => i, :j => j }]

  while positions.any?
    pos = positions.shift

    if pos[:i] >= 0 && pos[:i] < terrain.size && pos[:j] >= 0 && pos[:j] < terrain.first.size && terrain[pos[:i]][pos[:j]] == '.'
      terrain[pos[:i]][pos[:j]] = ' '

      positions += [
        { :i => pos[:i] + 1, :j => pos[:j]     },
        { :i => pos[:i] - 1, :j => pos[:j]     },
        { :i => pos[:i],     :j => pos[:j] + 1 },
        { :i => pos[:i],     :j => pos[:j] - 1 }
      ]
    end
  end

  terrain
end

instructions = []

block = File.read('./plan.txt').split("\n").collect do |line|
  line.split('').first

  instructions << {
    :dir      => line.split(' ').first.downcase,
    :distance => line.split(' ').first(2).last.to_i,
    :color    => line.split(' ').last.gsub('(', '').gsub(')', '')
  }
end

horizontal = limits(instructions, :horizontal)
vertical   = limits(instructions, :vertical)

puts horizontal
puts vertical

height = vertical[:max]   - vertical[:min]   + 1 + 2 # 2 to keep extra border outside
width  = horizontal[:max] - horizontal[:min] + 1 + 2 # 2 to keep extra border outside

terrain = Array.new(height) { Array.new(width) { '.' } }

#min

current_i = 0 - vertical[:min] + 1
current_j = 0 - horizontal[:min] + 1
terrain[current_i][current_j] = '#'

instructions.each do |instruction|
  instruction[:distance].times do
    current_i = current_i + 1 if instruction[:dir] == 'd'
    current_i = current_i - 1 if instruction[:dir] == 'u'
    current_j = current_j + 1 if instruction[:dir] == 'r'
    current_j = current_j - 1 if instruction[:dir] == 'l'
    terrain[current_i][current_j] = '#'
  end
end

terrain.each { |line| puts line.join }

terrain = paint_outside(terrain, 0, 0)

terrain.each { |line| puts line.join }

total = terrain.sum do |line|
  line.count('.') + line.count('#')
end

puts total
#pp instructions

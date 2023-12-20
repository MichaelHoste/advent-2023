class String
  def in?(array)
    array.include?(self)
  end
end

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

instructions = []

block = File.read('./plan.txt').split("\n").collect do |line|
  line.split('').first

  color = line.split(' ').last.gsub('#', '').gsub('(', '').gsub(')', '')

  dir = case color[-1]
        when "0"
          'r'
        when '1'
          'd'
        when '2'
          'l'
        when '3'
          'u'
        end

  distance = color[0...5].to_i(16)

  old_dir      = line.split(' ').first.downcase
  old_distance = line.split(' ').first(2).last.to_i

  previous = instructions.last

  instruction = {
    :dir      => old_dir,      #dir,     #old_dir,
    :distance => old_distance, #distance #old_distance,
  }

  if !previous
    instruction[:inside] = :bottom
  else
    # right
    if previous[:dir] == 'd' && instruction[:dir] == 'r' && previous[:inside] == :left
      instruction[:inside] = :bottom
    elsif previous[:dir] == 'd' && instruction[:dir] == 'r' && previous[:inside] == :right
      instruction[:inside] = :top
    elsif previous[:dir] == 'u' && instruction[:dir] == 'r' && previous[:inside] == :left
      instruction[:inside] = :top
    elsif previous[:dir] == 'u' && instruction[:dir] == 'r' && previous[:inside] == :right
      instruction[:inside] = :bottom
    end

    # left
    if previous[:dir] == 'd' && instruction[:dir] == 'l' && previous[:inside] == :left
      instruction[:inside] = :top
    elsif previous[:dir] == 'd' && instruction[:dir] == 'l' && previous[:inside] == :right
      instruction[:inside] = :bottom
    elsif previous[:dir] == 'u' && instruction[:dir] == 'l' && previous[:inside] == :left
      instruction[:inside] = :bottom
    elsif previous[:dir] == 'u' && instruction[:dir] == 'l' && previous[:inside] == :right
      instruction[:inside] = :top
    end

    # up
    if previous[:dir] == 'r' && instruction[:dir] == 'u' && previous[:inside] == :top
      instruction[:inside] = :left
    elsif previous[:dir] == 'r' && instruction[:dir] == 'u' && previous[:inside] == :bottom
      instruction[:inside] = :right
    elsif previous[:dir] == 'l' && instruction[:dir] == 'u' && previous[:inside] == :top
      instruction[:inside] = :right
    elsif previous[:dir] == 'l' && instruction[:dir] == 'u' && previous[:inside] == :bottom
      instruction[:inside] = :left
    end

    # down
    if previous[:dir] == 'r' && instruction[:dir] == 'd' && previous[:inside] == :top
      instruction[:inside] = :right
    elsif previous[:dir] == 'r' && instruction[:dir] == 'd' && previous[:inside] == :bottom
      instruction[:inside] = :left
    elsif previous[:dir] == 'l' && instruction[:dir] == 'd' && previous[:inside] == :top
      instruction[:inside] = :left
    elsif previous[:dir] == 'l' && instruction[:dir] == 'd' && previous[:inside] == :bottom
      instruction[:inside] = :right
    end
  end

  instructions << instruction
end

pp instructions

horizontal = limits(instructions, :horizontal)
vertical   = limits(instructions, :vertical)

puts horizontal
puts vertical

height = vertical[:max]   - vertical[:min]   + 1 + 2 # 2 to keep extra border outside
width  = horizontal[:max] - horizontal[:min] + 1 + 2 # 2 to keep extra border outside

puts height

#min

current_i = 0 - vertical[:min] + 1
current_j = 0 - horizontal[:min] + 1

cols = []
rows = []

instructions.each do |instruction|
  dir = instruction[:dir]

  if dir.in?(['d', 'u']) # detect vertical line ("col") limits
    if dir == 'd'
      cols << {
        :j      => current_j,
        :start  => current_i,
        :end    => current_i + instruction[:distance],
        :inside => instruction[:inside]
      }
    elsif dir == 'u'
      cols << {
        :j      => current_j,
        :start  => current_i - instruction[:distance],
        :end    => current_i,
        :inside => instruction[:inside]
      }
    end
  elsif dir.in?(['r', 'l']) # detect hozirontal line ("row") limits
    if dir == 'r'
      rows << {
        :i      => current_i,
        :start  => current_j,
        :end    => current_j + instruction[:distance],
        :inside => instruction[:inside]
      }
    elsif dir == 'l'
      rows << {
        :i      => current_i,
        :start  => current_j - instruction[:distance],
        :end    => current_j,
        :inside => instruction[:inside]
      }
    end
  end

  current_i = current_i + instruction[:distance] if instruction[:dir] == 'd'
  current_i = current_i - instruction[:distance] if instruction[:dir] == 'u'
  current_j = current_j + instruction[:distance] if instruction[:dir] == 'r'
  current_j = current_j - instruction[:distance] if instruction[:dir] == 'l'
end

puts cols.inspect
puts rows.inspect

puts "---------------------"

total = 0
i     = 0

while i < height
  if i%1000 == 0
    puts (i.to_f/height.to_f*100).round(2).to_s + "%"
  end

  intersect_cols = cols.select { |col| i >= col[:start]  && i <= col[:end] }.sort_by { |col| col[:j] }

  current_j = 0
  state     = :out

  intersect_cols.each do |col|
    puts col.inspect
    next_j      = col[:j]
    next_inside = col[:inside]

    #puts next_inside

    if state == :out
      total += 1

      print "add #{1} on line #{i} "

      if next_inside == :right
        puts "and go IN"
        state = :in
      else
        puts "and stay OUT"
      end
    elsif state == :in
      weight = next_j - current_j
      total += weight

      print "add #{weight} on line #{i} "

      if next_inside == :left && !rows.detect { |row| i == row[:i] && current_j == row[:end] }
        puts "and go OUT"
        state = :out
      else
        puts "and stay IN"
      end
    end

    puts "====="

    current_j = next_j
  end

  i = i + 1
end

puts total


# 112073595315148 too low

#pp instructions

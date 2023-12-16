class String
  def in?(array)
    array.include?(self)
  end
end

def display(contraption)
  contraption.each do |line|
    puts line.join
  end
end

def compute_force(contraption, beam)
  result = Array.new(contraption.size) {
    Array.new(contraption.first.size) { [] }
  }

  beams = [beam]

  while beams.any?
    beam = beams.shift

    dir, i, j = beam[:dir], beam[:i], beam[:j]

    if (dir == 'r' && j >= -1) || (dir == 'l' && j <= contraption.first.size) || (dir == 'd' && i >= -1) || (dir == 'u' && i <= contraption.size)
      case dir
      when 'r'
        j = j + 1
      when 'l'
        j = j - 1
      when 'u'
        i = i - 1
      when 'd'
        i = i + 1
      end

      if i >= 0 && j >= 0 && i < contraption.size && j < contraption.first.size
        cell     = contraption[i][j]
        new_dirs = []

        # Keep going
        if (cell == '-' && dir.in?(['r', 'l'])) || (cell == '|' && dir.in?(['u', 'd'])) || cell == '.'
          new_dirs << dir
        # Split vertically
        elsif cell == '|' && dir.in?(['l', 'r'])
          new_dirs << 'd'
          new_dirs << 'u'
        # Split horizontally
        elsif cell == '-' && dir.in?(['u', 'd'])
          new_dirs << 'r'
          new_dirs << 'l'
        # # Change directions
        elsif cell == '/'
          if dir == 'r'
            new_dirs << 'u'
          elsif dir == 'l'
            new_dirs << 'd'
          elsif dir == 'u'
            new_dirs << 'r'
          elsif dir == 'd'
            new_dirs << 'l'
          end
        elsif cell == "\\"
          if dir == 'l'
            new_dirs << 'u'
          elsif dir == 'r'
            new_dirs << 'd'
          elsif dir == 'd'
            new_dirs << 'r'
          elsif dir == 'u'
            new_dirs << 'l'
          end
        end

        new_dirs.each do |new_dir|
          if !result[i][j].include?(new_dir)
            beams.unshift({ :i => i, :j => j, :dir => new_dir })
            result[i][j] << new_dir
          end
        end
      end
    end
  end

  # display(contraption)
  # puts ""
  # display(as_array(result))

  result.collect do |line|
    line.count { |cell| cell.any? }
  end.sum
end

contraption = File.read('./contraption.txt').split("\n").collect do |line|
  chars = line.split('')
end

start_beams = []

# from top
(0...contraption.first.size).each do |j|
  start_beams << { :i => -1, :j => j, :dir => 'd' }
end

# from bottom
(0...contraption.first.size).each do |j|
  start_beams << { :i => contraption.size, :j => j, :dir => 'u' }
end

# from left
(0...contraption.size).each do |i|
  start_beams << { :i => i, :j => -1, :dir => 'r' }
end

# from right
(0...contraption.size).each do |i|
  start_beams << { :i => i, :j => contraption.first.size, :dir => 'l' }
end

puts (start_beams.collect do |start_beam|
  compute_force(contraption, start_beam)
end.max)

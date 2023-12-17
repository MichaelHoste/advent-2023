class String
  def in?(array)
    array.include?(self)
  end
end


def keep_relevant_moves(node)
  to_keep = 1

  (2..10).each do |num|
    if node[:moves].last(num).uniq.size == 1
      to_keep = num
    else
      break
    end
  end

  node[:moves] = node[:moves].last(to_keep)

  return node
end

def evaluate_h(block, node)
  vertical   = block.size-1 - node[:i]
  horizontal = block.first.size-1 - node[:j]

  vertical + horizontal + vertical/3 + horizontal/3
end

def create_hash_key(node)
  new_node = node.except(:eval)
  hash_key = "#{node[:i]}|#{node[:j]}|#{node[:moves].join}"
end

block = File.read('./block.txt').split("\n").collect do |line|
  line.split('').collect(&:to_i)
end

visited_nodes = {}

stack = [{
  :i      => 0,
  :j      => 0,
  :total  => 0,
  :moves  => []
}]

current_weight = 0

while true
  node = stack.shift

  # Print current weight
  if node[:total] > current_weight
    current_weight = node[:total]
    #puts current_weight
  end

  # Print result that was found
  if node[:i] == block.size-1 && node[:j] == block.first.size-1
    puts node.inspect
    puts node[:total]
    puts "stack size: #{stack.size}"
    break
  end

  next_nodes = []

  # Go left
  if node[:moves].empty? || node[:moves].last == 'l' || node[:moves].last(4).join.in?(['dddd', 'uuuu'])
    i = node[:i]
    j = node[:j] - 1
    if j >= 0
      next_nodes << {
        :i      => i,
        :j      => j,
        :total  => node[:total] + block[i][j],
        :moves  => node[:moves] + ['l']
      }
    end
  end

  # Go right
  if node[:moves].empty? || node[:moves].last == 'r' || node[:moves].last(4).join.in?(['dddd', 'uuuu'])
    i = node[:i]
    j = node[:j] + 1
    if j < block.first.size
      next_nodes << {
        :i      => i,
        :j      => j,
        :total  => node[:total] + block[i][j],
        :moves  => node[:moves] + ['r']
      }
    end
  end

  # Go up
  if node[:moves].empty? || node[:moves].last == 'u' || node[:moves].last(4).join.in?(['llll', 'rrrr'])
    i = node[:i] - 1
    j = node[:j]
    if i >= 0
      next_nodes << {
        :i      => i,
        :j      => j,
        :total  => node[:total] + block[i][j],
        :moves  => node[:moves] + ['u']
      }
    end
  end

  # Go down
  if node[:moves].empty? || node[:moves].last == 'd' || node[:moves].last(4).join.in?(['llll', 'rrrr'])
    i = node[:i] + 1
    j = node[:j]
    if i < block.size
      next_nodes << {
        :i      => i,
        :j      => j,
        :total  => node[:total] + block[i][j],
        :moves  => node[:moves] + ['d']
      }
    end
  end

  # Reject potential nodes with 11 moves in same direction!
  next_nodes = next_nodes.reject do |next_node|
    next_node[:moves].size >= 11 && next_node[:moves].last(11).uniq.size == 1
  end

  # Create evaluation of nodes (distance travelled + lower estimation of distance remaining)
  next_nodes = next_nodes.each do |next_node|
    next_node[:eval] = next_node[:total] + evaluate_h(block, next_node)
  end

  next_nodes.each do |next_node|
    next_node = keep_relevant_moves(next_node)
    hash_key  = create_hash_key(next_node)

    if !visited_nodes[hash_key] || next_node[:total] < visited_nodes[hash_key]
      visited_nodes[hash_key] = next_node[:total]

      new_index = stack.bsearch_index { |node| node[:eval] >= next_node[:eval] } || stack.size

      stack.insert(new_index, next_node)
    end
  end
end

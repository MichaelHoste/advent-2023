puts (File.read('./cards.txt').gsub(/Card\s+\d+: /, '').split("\n").sum do |line|
  nums, wins = line.split(' | ').collect { |n| n.split(' ').collect(&:to_i) }
  (2**(24 - (wins-nums).size)).to_f.floor
end)

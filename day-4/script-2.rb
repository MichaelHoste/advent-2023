lines = File.read('./cards.txt').gsub(/Card\s+\d+: /, '').split("\n")

cards = lines.collect do |line|
  nums, wins = line.split(' | ').collect { |n| n.split(' ').collect(&:to_i) }

  {
    :num_of_cards     => 1,
    :matching_numbers => (25 - (wins-nums).size).to_i
  }
end

cards.each_with_index do |card, index|
  card[:matching_numbers].times do |i|
    j = index+i+1
    cards[j][:num_of_cards] += card[:num_of_cards] if j < cards.size
  end
end

puts cards.sum { |card| card[:num_of_cards] }


def five_or_kind?(cards)
  cards.uniq.size == 1
end

def four_of_kind?(cards)
  only_2_numbers = cards.uniq.size == 2
  cards_1_and_4  = [1, 4].include?((cards - [cards.uniq.first]).size)

  only_2_numbers && cards_1_and_4
end

def full_house?(cards)
  only_2_numbers = cards.uniq.size == 2
  cards_2_and_3  = [2, 3].include?((cards - [cards.uniq.first]).size)

  only_2_numbers && cards_2_and_3
end

def three_of_a_kind?(cards)
  only_3_numbers   = cards.uniq.size == 3
  number_1_3_times = cards.count(cards.uniq[0]) == 3
  number_2_3_times = cards.count(cards.uniq[1]) == 3
  number_3_3_times = cards.count(cards.uniq[2]) == 3
  !full_house?(cards) && (number_1_3_times || number_2_3_times || number_3_3_times)
end

def two_pair?(cards)
  only_3_numbers = cards.uniq.size == 3
  only_3_numbers && !three_of_a_kind?(cards)
end

def one_pair?(cards)
  cards.uniq.size == 4
end

lines = File.read('./hands.txt').split("\n")

hands = lines.collect do |line|
  cards = line.split(" ").first.chars.collect do |char|
    case char
    when 'T'
      10
    when 'J'
      11
    when 'Q'
      12
    when 'K'
      13
    when 'A'
      14
    else
      char.to_i
    end
  end

  {
    :cards => cards,
    :bid   => line.split(" ").last.to_i
  }
end

hands = hands.sort_by do |hand|
  if five_or_kind?(hand[:cards])
    [6] + hand[:cards]
  elsif four_of_kind?(hand[:cards])
    [5] + hand[:cards]
  elsif full_house?(hand[:cards])
    [4] + hand[:cards]
  elsif three_of_a_kind?(hand[:cards])
    [3] + hand[:cards]
  elsif two_pair?(hand[:cards])
    [2] + hand[:cards]
  elsif one_pair?(hand[:cards])
    [1] + hand[:cards]
  else
    [0] + hand[:cards]
  end
end

puts hands.collect.with_index { |hand, i| (i+1) * hand[:bid] }.sum

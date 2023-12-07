def five_of_kind?(cards)
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

def more_occurences(cards)
  cards.reject { |card| card == 11 }.sort_by { |number| cards.count(number) }.last
end

def jokerize(cards)
  number = more_occurences(cards)

  cards.collect { |card| card == 11 ? number : card }
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
    :joker_cards => jokerize(cards),
    :weak_cards  => cards.collect { |card| card == 11 ? 0 : card }, # Replace 'J' with 0
    :bid         => line.split(" ").last.to_i
  }
end

hands = hands.sort_by do |hand|
  joker_cards = hand[:joker_cards]
  weak_cards  = hand[:weak_cards]

  if five_of_kind?(joker_cards)
    [6] + weak_cards
  elsif four_of_kind?(joker_cards)
    [5] + weak_cards
  elsif full_house?(joker_cards)
    [4] + weak_cards
  elsif three_of_a_kind?(joker_cards)
    [3] + weak_cards
  elsif two_pair?(joker_cards)
    [2] + weak_cards
  elsif one_pair?(joker_cards)
    [1] + weak_cards
  else
    [0] + weak_cards
  end
end

puts hands.collect.with_index { |hand, i| (i+1) * hand[:bid] }.sum

games = File.read('./games.txt').split("\n")

good_games = games.reject do |game|
  parts = game.split(/,|;|:/).collect(&:strip).drop(1) # ["6 red", "1 blue", "3 green", "2 blue", "1 red", "2 green"]

  red   = parts.detect { |part| part.include?('red')   && part.to_i > 12 }
  green = parts.detect { |part| part.include?('green') && part.to_i > 13 }
  blue  = parts.detect { |part| part.include?('blue')  && part.to_i > 14 }

  red || green || blue
end

answer = good_games.sum { |game| game.gsub('Game ', '').to_i }

puts answer

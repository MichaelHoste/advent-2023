games = File.read('./games.txt').split("\n")

answer = games.sum do |game|
  parts = game.split(/,|;|:/).collect(&:strip).drop(1) # ["6 red", "1 blue", "3 green", "2 blue", "1 red", "2 green"]

  red   = parts.select { |part| part.include?('red')   }.collect(&:to_i).max
  green = parts.select { |part| part.include?('green') }.collect(&:to_i).max
  blue  = parts.select { |part| part.include?('blue')  }.collect(&:to_i).max

  red * green * blue
end

puts answer

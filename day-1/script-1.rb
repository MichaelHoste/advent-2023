sentences = File.read('./calibration.txt').split("\n")

answer = sentences.sum do |sentence|
  numbers = sentence.gsub(/[a-z]/, '').chars
  "#{numbers.first}#{numbers.last}".to_i
end

puts answer

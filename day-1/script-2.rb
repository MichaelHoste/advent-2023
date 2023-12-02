sentences = File.read('./calibration.txt')
                .gsub('one',   'o1e')
                .gsub('two',   't2o')
                .gsub('three', 't3e')
                .gsub('four',  'f4r')
                .gsub('five',  'f5e')
                .gsub('six',   's6x')
                .gsub('seven', 's7n')
                .gsub('eight', 'e8t')
                .gsub('nine',  'n9e')
                .split("\n")

answer = sentences.sum do |sentence|
  numbers = sentence.gsub(/[a-z]/, '').chars
  "#{numbers.first}#{numbers.last}".to_i
end

puts answer

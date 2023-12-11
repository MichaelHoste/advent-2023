lines     = File.read('./paper.txt').split("\n")
times     = [lines.first.split(':').last.strip.gsub(/\s+/, '').to_i]
distances = [lines.last.split(':').last.strip.gsub(/\s+/, '').to_i]

win_count = times.collect.with_index do |time, index|
  (0..time).select do |start_delay|
    (time - start_delay) * start_delay > distances[index]
  end
end.collect { |wins| wins.count }

puts win_count.inject(:*)

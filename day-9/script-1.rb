def next_number(numbers)
  differences = numbers.collect.with_index do |number, i|
    numbers[i+1] - number if i < numbers.size - 1
  end.compact

  if differences.all? { |num| num == 0 }
    numbers.last
  else
    numbers.last + next_number(differences)
  end
end

histories = File.read('./history.txt').split("\n").collect do |history|
  history.split(' ').collect(&:to_i)
end

puts (histories.sum do |numbers|
  next_number(numbers)
end)


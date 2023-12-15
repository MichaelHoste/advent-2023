def box_number(chars)
  value = 0

  chars.each_byte do |byte|
    value = (value + byte) * 17 % 256
  end

  value
end

instructions = File.read('./ascii.txt').split(',').collect(&:strip)
boxes = {}

instructions.collect do |instruction|
  box_chars  = instruction.split('-').first.split('=').first
  box_number = box_number(box_chars)

  boxes[box_number] ||= []

  if instruction.include?('=')
    name = instruction.split('=').join(' ')

    if boxes[box_number].any? { |lens| lens.include?(name.split(' ').first) }
      boxes[box_number].collect! { |lens| lens.include?(name.split(' ').first) ? name : lens }
    else
      boxes[box_number] << name
    end
  else
    name = instruction.gsub('-', '')
    boxes[box_number] = boxes[box_number].reject { |lens| lens.include?(name) }
  end
end

total = boxes.collect do |number, lenses|
  lenses.collect.with_index do |lens, i|
    (number + 1) * lens.split(' ').last.to_i * (i + 1)
  end.sum
end.sum

puts total

instructions = File.read('./ascii.txt').split(',').collect(&:strip)

values = instructions.collect do |instruction|
  value = 0

  instruction.each_byte do |byte|
    value = (value + byte) * 17 % 256
  end

  value
end

puts values.sum.inspect

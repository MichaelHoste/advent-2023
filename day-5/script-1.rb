def create_conversion_array(rules)
  array = (0..99).to_a

  rules.each do |rule|
    destination_start = rule.split(' ')[0].to_i
    source_start      = rule.split(' ')[1].to_i
    range             = rule.split(' ')[2].to_i

    offset = 0
    (source_start..(source_start+range-1)).each_with_index do |index|
      array[index] = destination_start + offset
      offset += 1
    end
  end

  array
end

file_content = File.read('./almanac.txt')

seeds    = file_content.lines.first.split(': ').last.split(' ').collect(&:to_i)
mappings = file_content.split("\n\n").collect(&:strip).drop(1)
steps    = ['seed', 'soil', 'fertilizer', 'water', 'light', 'temperature', 'humidity', 'location']

conversions_hash = {}

mappings.each do |mapping|
  parts = mapping.split("\n")
  title = parts.first.gsub('-to-', '-').gsub(' map:', '')
  rules = parts.drop(1)

  conversions_hash[title] = create_conversion_array(rules)
end

min_seed = seeds.collect do |seed|
  steps.each_with_index do |step, index|
    if index < steps.size - 1
      seed = conversions_hash["#{steps[index]}-#{steps[index+1]}"][seed]
    end
  end

  seed
end.min

#pp conversions_hash

puts min_seed


#puts conversions_hash.inspect


# conversions["seed-soil"][4]

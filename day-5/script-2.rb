def create_hash_rules(rules)
  hash_rules = {}

  rules.each do |rule|
    destination_start = rule.split(' ')[0].to_i
    source_start      = rule.split(' ')[1].to_i
    range             = rule.split(' ')[2].to_i

    hash_rules[(source_start..(source_start+range-1))] = destination_start
  end

  hash_rules
end

file_content = File.read('./almanac.txt')

seeds       = file_content.lines.first.split(': ').last.split(' ').collect(&:to_i)
seed_ranges = seeds.collect.with_index do |seed, i|
  if i % 2 == 0
    (seed..(seed+seeds[i+1]-1))
  else
    nil
  end
end.compact

mappings = file_content.split("\n\n").collect(&:strip).drop(1)
steps    = ['seed', 'soil', 'fertilizer', 'water', 'light', 'temperature', 'humidity', 'location']

conversions_hash = {}

mappings.each do |mapping|
  parts = mapping.split("\n")
  title = parts.first.gsub('-to-', '-').gsub(' map:', '')
  rules = parts.drop(1)

  conversions_hash[title] = create_hash_rules(rules)
end

pp conversions_hash

min_seed = 1_000_000_000_000

seed_ranges.each do |seed_range|
  total = 0

  seed_range.each do |seed|
    if seed % 100_000 == 0
      total += 100_000
      range_size = seed_range.max - seed_range.min
      puts "#{(total.to_f/range_size*100.0).round(2)}% of #{range_size} (min: #{min_seed})"
    end

    steps.each_with_index do |step, index|
      if index < steps.size - 1
        hash_rules = conversions_hash["#{steps[index]}-#{steps[index+1]}"]

        range = hash_rules.keys.detect { |range| range.include?(seed) }

        if range
          seed = hash_rules[range] + (seed - range.min)
        end
      end
    end

    min_seed = seed if seed < min_seed
  end

  puts "Min Seed for #{seed_range.max - seed_range.min}: #{min_seed}"
end

#pp conversions_hash

puts min_seed

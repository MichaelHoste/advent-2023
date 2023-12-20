rules_content, parts_content = File.read('./system.txt').split("\n\n")

parts = eval(
  "[" + parts_content.gsub("x=", ":x=>")
                     .gsub("m=", ":m=>")
                     .gsub("a=", ":a=>")
                     .gsub("s=", ":s=>")
                     .gsub('}', '},') + "]"
)

rules = rules_content.split("\n").collect do |rule_line|
  name = rule_line.split('{').first

  actions = rule_line.split('{').last.gsub('}', '').split(',').collect do |condition_text|
    action = {
      :condition => condition_text.split(':').first,
      :value    => condition_text.split(':').last
    }

    # Last one without condition
    action[:condition] = 'true' if action[:condition] == action[:value]

    action
  end

  [ name, actions ]
end.to_h


parts = parts.select do |part|
  current = 'in'

  while !['A', 'R'].include?(current)
    actions = rules[current]
    actions.each do |action|
      x, m, a, s = part.values

      #puts action[:condition]
      if eval(action[:condition])
        current = action[:value]
        break
      end
    end
  end

  current == 'A'
end

puts parts.collect { |part | part.values.sum }.sum

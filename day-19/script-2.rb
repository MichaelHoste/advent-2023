rules_content, parts_content = File.read('./system.txt').split("\n\n")

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

parts = [{
  :x    => [1, 4000],
  :m    => [1, 4000],
  :a    => [1, 4000],
  :s    => [1, 4000],
  :name => 'in'
}]

accepted_parts = []

while parts.any?
  # puts parts.inspect
  part = parts.shift

  current = part[:name]

  if current == 'A'
    accepted_parts << part
  elsif current == 'R'
    # REJECTED so nothing
  else
    actions = rules[current]

    actions.each do |action|
      condition = action[:condition]
      letter    = condition.split(/[<>]/).first
      number    = condition.split(/[<>]/).last.to_i
      operation = condition.match(/[<>]/).to_s

      current_range = part[letter.to_sym]

      if operation == '<' || operation == '>'
        if operation == '<'
          new_range_success = [current_range[0], number - 1      ]
          new_range_fail    = [number,           current_range[1]]
        elsif operation == '>'
          new_range_success = [number + 1,       current_range[1]]
          new_range_fail    = [current_range[0], number          ]
        end

        # Redirect to new rule (and stop these actions)
        if new_range_success[0] <= new_range_success[1]
          parts.unshift part.merge({
            letter.to_sym => new_range_success,
            :name         => action[:value]
          })
        end

        # Keep going the following rules
        if new_range_fail[0] <= new_range_fail[1]
          part.merge!({
            letter.to_sym => new_range_fail
          })
        end
      else
        # Redirect to new rule (and stop these actions)
        parts.unshift part.merge({
          :name => action[:value]
        })
      end
    end
  end
end

puts (accepted_parts.collect do |part|
  x = (part[:x][1] - part[:x][0] + 1)
  m = (part[:m][1] - part[:m][0] + 1)
  a = (part[:a][1] - part[:a][0] + 1)
  s = (part[:s][1] - part[:s][0] + 1)
  x*m*a*s
end.sum)

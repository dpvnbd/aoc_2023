NODES_REGEX = /(?<node>\w{3}) = \((?<L>\w{3}), (?<R>\w{3})\)/

def calculate(text)
  directions = text.split("\n").first.chars

  nodes = {}
  text.scan(NODES_REGEX) do |node, left, right|
    nodes[node] = { 'L' => left, 'R' => right }
  end

  current_nodes = nodes.keys.select { |k| k.end_with?('A') }

  periods = current_nodes.map do |node|
    puts "Checking node #{node}"
    period = 0

    directions.cycle.each do |direction|
      node = nodes[node][direction]
      period += 1
      break if node.end_with?('Z')
    end

    puts "PERIOD FOR #{node}: #{period}"
    period
  end

  periods.reduce(:lcm)
end

pp calculate(File.read(File.expand_path('./day8/input.txt')))

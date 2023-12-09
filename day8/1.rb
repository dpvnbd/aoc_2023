NODES_REGEX = /(?<node>\w{3}) = \((?<L>\w{3}), (?<R>\w{3})\)/
START_NODE = 'AAA'
END_NODE = 'ZZZ'

def calculate(text)
  directions = text.split("\n").first.chars

  nodes = {}
  text.scan(NODES_REGEX) do |node, left, right|
    nodes[node] = { 'L' => left, 'R' => right}
  end

  current_node = START_NODE
  steps = 0

  directions.cycle.each do |direction|
    current_node = nodes[current_node][direction]
    steps += 1
    return steps if current_node == END_NODE
  end
end


pp calculate(File.read(File.expand_path('./day8/input.txt')))

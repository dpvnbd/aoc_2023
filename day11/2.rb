EXPANSION_SIZE = 1000000
EXPANSION = 'o'

def expand_vertical(original_space)
  space = []
  original_space.each do |line|
    space << if line.include?('#')
               line.dup
             else
               Array.new(line.size, EXPANSION)
             end
  end
  space
end

def adjacent_cells(space, point)
  result = []

  [[0, 1], [1, 0], [0, -1], [-1, 0]].each do |offset_x, offset_y|
    x = point[0] + offset_x
    y = point[1] + offset_y
    next if x < 0 || x >= space.size || y < 0 || y >= space[x].size

    result << [x, y]
  end
  result
end

def distance(space, point1, point2)
  (point2[0] - point1[0]).abs + (point2[1] - point1[1]).abs
end

def calculate(text)
  space = text.split("\n").map(&:chars)

  # puts "Original"
  # puts space.map(&:join).join("\n")

  space = expand_vertical(space)
  space = expand_vertical(space.transpose).transpose

  # puts "New: "
  # puts space.map(&:join).join("\n")

  galaxies = []

  expanded_x = 0
  space.each_with_index do |row, x|
    if row.first == EXPANSION
      expanded_x += EXPANSION_SIZE - 1
      next
    end

    expanded_y = 0
    row.each_with_index do |cell, y|
      if cell == EXPANSION
        expanded_y += EXPANSION_SIZE - 1
        next
      end

      next unless cell == '#'

      galaxies << [x + expanded_x, y + expanded_y]
    end
  end

  galaxy_pairs = []
  galaxies.each_with_index do |galaxy, index|
    galaxies[(index + 1)..].each do |other_galaxy|
      galaxy_pairs << [galaxy, other_galaxy]
    end
  end

  pairs_size = galaxy_pairs.size
  galaxy_pairs.each_with_index.map do |pair, index|
    distance(space, *pair)
  end.sum

end

pp calculate(File.read(File.expand_path('./day11/input.txt')))

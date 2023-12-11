def expand_vertical(original_space)
  space = []
  original_space.each do |line|
    space << line.dup
    next if line.include?('#')

    space << line.dup
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

  space.each_with_index do |row, x|
    row.each_with_index do |cell, y|
      next unless cell == '#'

      galaxies << [x, y]
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

pp calculate(File.read(File.expand_path('./day11/test_input.txt')))

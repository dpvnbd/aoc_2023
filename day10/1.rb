VISUALIZATIONS = {
  '|' => '║', '-' => '═', 'L' => '╚', 'J' => '╝', '7' => '╗', 'F' => '╔'
}.freeze

DIRECTIONS = %w[↑ ↓ → ←].freeze

NODE_DIRECTIONS = {
  '║' => { '↑' => '↑', '↓' => '↓' },
  '═' => { '→' => '→', '←' => '←' },
  '╚' => { '↓' => '→', '←' => '↑' },
  '╝' => { '→' => '↑', '↓' => '←' },
  '╗' => { '→' => '↓', '↑' => '←' },
  '╔' => { '↑' => '→', '←' => '↓' },
  'S' => DIRECTIONS.zip(DIRECTIONS).to_h
}.freeze

DIRECTION_OFFSETS = {
  '↑' => [-1, 0],
  '↓' => [1, 0],
  '→' => [0, 1],
  '←' => [0, -1]
}.freeze

class Maze
  attr_reader :chars

  def initialize(array)
    @chars = array.map(&:dup)
    @size_x = @chars.size
    @size_y = @chars.first.size
  end

  def mark_loop!(start_x, start_y, direction, distance = 0)
    loop do
      return if start_x < 0 || start_x >= @size_x || start_y < 0 || start_y >= @size_y

      node = @chars[start_x][start_y]

      puts "#{direction} #{node} at (#{start_x}, #{start_y}) => #{distance}"
      return distance if node == 'S' && distance != 0

      next_direction = NODE_DIRECTIONS.dig(node, direction)
      return unless next_direction

      offset_x, offset_y = DIRECTION_OFFSETS[next_direction]
      start_x += offset_x
      start_y += offset_y
      direction = next_direction
      distance += 1
    end
  end
end

def calculate(text)
  VISUALIZATIONS.each do |sym, s|
    text.gsub!(sym, s)
  end
  puts text

  maze = Maze.new(text.split("\n").map(&:chars))

  start_line = maze.chars.detect { |line| line.include?('S') }
  start_x = maze.chars.index(start_line)
  start_y = start_line.index('S')
  puts "Starting at (#{start_x}, #{start_y})"

  DIRECTIONS.each do |direction|
    length = maze.loop_length(start_x, start_y, direction)
    return length / 2 if length
  end
end

pp calculate(File.read(File.expand_path('./day10/input.txt')))

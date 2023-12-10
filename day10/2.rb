# Do you think God stays in heaven because
# he too lives in fear of what he has created?

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

LOOP_ELEMENTS = %w[*].freeze

class Maze
  attr_reader :chars

  def initialize(array)
    @chars = array.map(&:dup)
    @size_x = @chars.size
    @size_y = @chars.first.size
  end

  def mark_loop!(start_x, start_y, direction)
    current_chars = @chars.map(&:dup)
    distance = 0

    loop do
      return if start_x < 0 || start_x >= @size_x || start_y < 0 || start_y >= @size_y

      node = current_chars[start_x][start_y]

      # puts "#{direction} #{node} at (#{start_x}, #{start_y}) => #{distance}"
      if LOOP_ELEMENTS.include?(node) && distance != 0
        @chars = strip(current_chars)
        return distance
      end

      next_direction = NODE_DIRECTIONS.dig(node, direction)
      return unless next_direction

      current_chars[start_x][start_y] = '*'

      offset_x, offset_y = DIRECTION_OFFSETS[next_direction]
      start_x += offset_x
      start_y += offset_y
      direction = next_direction
      distance += 1
    end
  end

  def strip(current_chars)
    new_chars = @chars.map(&:dup)

    current_chars.each_with_index do |line, x|
      line.each_with_index do |c, y|
        unless LOOP_ELEMENTS.include?(c)
          new_chars[x][y] = '.'
        end
      end
    end

    new_chars.map do |line|
      line_text = line.join
      line_text.gsub!('═', '')
      line_text.gsub!('╔╝', '║')
      line_text.gsub!('╚╗', '║')
      line_text.chars
    end
  end

  def calculate_start_node!(start_x, start_y)
    directions = []

    DIRECTION_OFFSETS.invert.each do |offsets, direction|
      offset_x, offset_y = offsets
      x = start_x + offset_x
      y = start_y + offset_y

      next if x < 0 || x >= @size_x || y < 0 || y >= @size_y

      node = @chars[x][y]
      node_available = NODE_DIRECTIONS[node].keys.include?(direction)

      directions << direction if node_available
    end

    start_node = case directions.sort
                 when %w[← ↑]
                   '╝'
                 when %w[← →]
                   '═'
                 when %w[← ↓]
                   '╗'
                 when %w[↑ →]
                   '╚'
                 when %w[↑ ↓]
                   '║'
                 when %w[→ ↓]
                   '╔'
                 end
    @chars[start_x][start_y] = start_node
  end

  def calculate_points!
    total = 0

    @chars.each_with_index do |line, x|
      line.each_with_index do |c, y|
        next unless c == '.'

        intersections = line[(y + 1)..].count do |c|
          c != '.'
        end

        total += 1 if intersections.odd?
      end
    end

    total
  end
end

def calculate(text)
  VISUALIZATIONS.each do |sym, s|
    text.gsub!(sym, s)
  end
  # puts text

  maze = Maze.new(text.split("\n").map(&:chars))

  start_line = maze.chars.detect { |line| line.include?('S') }
  start_x = maze.chars.index(start_line)
  start_y = start_line.index('S')

  maze.calculate_start_node!(start_x, start_y)

  DIRECTIONS.each do |direction|
    length = maze.mark_loop!(start_x, start_y, direction)
    break if length
  end


  maze.calculate_points!
end

pp calculate(File.read(File.expand_path('./day10/input.txt')))

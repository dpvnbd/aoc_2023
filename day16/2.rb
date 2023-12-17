# frozen_string_literal: true
require 'benchmark'

def traverse(x, y, direction)
  loop do
    break if x.negative? || y.negative? || x >= @grid.size || y >= @grid.first.size

    cache_key = "#{x},#{y},#{direction[0]},#{direction[1]}"
    break if @visited_beams.key?(cache_key)

    @visited_beams[cache_key] = true
    @energized_grid[x][y] = true

    case @grid[x][y]
    when '|'
      case direction
      when [0, 1], [0, -1]
        traverse(x - 1, y, [-1, 0])
        traverse(x + 1, y, [1, 0])
        break
      end

    when '-'
      case direction
      when [1, 0], [-1, 0]
        traverse(x, y + 1, [0, 1])
        traverse(x, y - 1, [0, -1])
        break
      end
    when '/'
      case direction
      when [0, 1]
        x -= 1
        direction = [-1, 0]
      when [0, -1]
        x += 1
        direction = [1, 0]
      when [1, 0]
        y -= 1
        direction = [0, -1]
      when [-1, 0]
        y += 1
        direction = [0, 1]
      end
      next
    when '\\'
      case direction
      when [0, 1]
        x += 1
        direction = [1, 0]
      when [0, -1]
        x -= 1
        direction = [-1, 0]
      when [1, 0]
        y += 1
        direction = [0, 1]
      when [-1, 0]
        y -= 1
        direction = [0, -1]
      end
      next
    end

    x += direction[0]
    y += direction[1]
  end
end

def count_grid_sides
  energized_counts = []

  @grid.first.each_index do |y|
    @energized_grid = Array.new(@grid.size) { Array.new(@grid.first.size, false) }
    @visited_beams = {}
    traverse(0, y, [1, 0])
    energized_counts << @energized_grid.inject(0) { |sum, row| sum + row.count(true) }

    @energized_grid = Array.new(@grid.size) { Array.new(@grid.first.size, false) }
    @visited_beams = {}
    traverse(@grid.size - 1, y, [-1, 0])
    energized_counts << @energized_grid.inject(0) { |sum, row| sum + row.count(true) }
  end

  @grid.each_index do |x|
    @energized_grid = Array.new(@grid.size) { Array.new(@grid.first.size, false) }
    @visited_beams = {}
    traverse(x, 0, [0, 1])
    energized_counts << @energized_grid.inject(0) { |sum, row| sum + row.count(true) }

    @energized_grid = Array.new(@grid.size) { Array.new(@grid.first.size, false) }
    @visited_beams = {}
    traverse(x, @grid.first.size - 1, [0, -1])
    energized_counts << @energized_grid.inject(0) { |sum, row| sum + row.count(true) }
  end

  energized_counts
end

def calculate(text)
  @grid = text.split("\n").map(&:chars)

  result = nil
  time = Benchmark.realtime do
    result = count_grid_sides.max
  end
  puts "Time: #{time} seconds"

  result
end

pp calculate(File.read(File.expand_path('./day16/input.txt')))

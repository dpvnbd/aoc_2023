require 'benchmark'

@visited_beams = {}

def traverse(x, y, direction)
  loop do
    if x < 0 || y < 0 || x >= @grid.size || y >= @grid.first.size
      break
    end

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

def calculate(text)
  @grid = text.split("\n").map(&:chars)
  @energized_grid = Array.new(@grid.size) { Array.new(@grid.first.size, false) }

  result = nil
  time = Benchmark.realtime do

    traverse(0, 0, [0, 1])

    puts "ENERGIZED"
    @energized_grid.each do |row|
      puts(row.map { |c| c ? '#' : '.' }.join(' '))
    end

    result = @energized_grid.inject(0) { |sum, row| sum + row.count(true) }
  end
  puts "Time: #{time} seconds"

  result
end

pp calculate(File.read(File.expand_path('./day16/input.txt')))

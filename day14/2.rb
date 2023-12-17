require 'benchmark'
CYCLES = 1_000_000_000

def slide(original_platform, direction)
  platform = case direction
             when :north, :south
               original_platform.transpose
             when :east, :west
               original_platform.map(&:dup)
             end

  swap_order = case direction
               when :north, :west
                 %w[. O]
               when :east, :south
                 %w[O .]
               end

  result = platform.each_with_index.map do |row, row_i|
    loop do
      swapped = false

      (1..row.size).each do |i|
        next unless row[i - 1] == swap_order[0] && row[i] == swap_order[1]

        row[i - 1], row[i] = row[i], row[i - 1]
        swapped = true
      end

      break unless swapped
    end

    row
  end

  case direction
  when :north, :south
    result.transpose
  else
    result
  end
end

def count_weight(platform)
  platform.each_with_index.map do |row, index|
    boulders_count = row.count('O')
    distance = platform.size - index

    boulders_count * distance
  end.sum
end

@cache = {}

def calculate(text)
  platform = text.split("\n").map(&:chars)

  result = nil

  time = Benchmark.realtime do
    new_platform = platform

    iterations = 0
    loop do
      puts "#{iterations}"

      if @cache.key?(new_platform)
        loop_offset = @cache[new_platform]
        period = iterations - loop_offset + 1
        target_iteration = (CYCLES - iterations) % period + loop_offset
        new_platform = @cache.key(target_iteration)
        break
      end
      iterations += 1

      unless @cache.key?(new_platform)
        @cache[new_platform] = iterations
      end

      new_platform = %i[north west south east].inject(new_platform) do |platform_result, direction|
        slide(platform_result, direction)
      end
    end

    puts new_platform.map(&:join).join("\n")
    result = count_weight(new_platform)

  end
  puts "Time: #{time} seconds"

  result
end

pp calculate(File.read(File.expand_path('./day14/input.txt')))

require 'benchmark'

def slide(original_platform)
  result = original_platform.transpose.map do |row|
    loop do
      swapped = false

      (1..row.size).each do |i|
        next unless row[i - 1] == '.' && row[i] == 'O'

        row[i - 1], row[i] = row[i], row[i - 1]
        swapped = true
      end

      break unless swapped
    end

    row
  end

  result.transpose
end

def count_weight(platform)
  platform.each_with_index.map do |row, index|
    boulders_count = row.count('O')
    distance = platform.size - index

    boulders_count * distance
  end.sum
end

def calculate(text)
  platform = text.split("\n").map(&:chars)

  result = nil

  time = Benchmark.realtime do
    new_platform = slide(platform)
    puts new_platform.map(&:join).join("\n")

    result = count_weight(new_platform)
  end
  puts "Time: #{time} seconds"

  result
end

pp calculate(File.read(File.expand_path('./day14/input.txt')))

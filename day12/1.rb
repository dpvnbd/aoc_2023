require 'benchmark'

def count_arrangements(springs, counts)
  # puts "CHECKING #{springs}"

  springs.each_with_index do |spring, index|
    next unless spring == '?'

    filled = count_arrangements(springs.dup.fill('#', index, 1), counts)
    empty = count_arrangements(springs.dup.fill('.', index, 1), counts)
    return filled + empty
  end

  groups = springs.join.scan(/[^.]+/).map(&:size)
  groups == counts ? 1 : 0
end

def calculate(text)
  spring_rows = []
  broken_counts = []

  text.split("\n").each do |line|
    spring_rows << line.split(' ').first.gsub(/\.+/, '.').chars
    broken_counts << line.scan(/\d+/).map(&:to_i)
  end

  size = spring_rows.size

  result = nil
  time = Benchmark.realtime do
    result = spring_rows.each_with_index.map do |springs, index|
      result = count_arrangements(springs, broken_counts[index])
      puts "#{index}/#{size}: #{springs.join} => #{result}"
      result
    end.sum
  end
  puts "Time: #{time} seconds"

  result
end

pp calculate(File.read(File.expand_path('./day12/input.txt')))

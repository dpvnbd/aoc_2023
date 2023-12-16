require 'benchmark'

def count_symmetry_horizontal(pattern = [])
  pattern.each_with_index do |row, i|
    pattern[i + 1..].each_with_index do |matching_row, matching_i|
      next unless matching_row == row

      matching_row_i = matching_i + i + 1

      middle_rows = pattern[i..matching_row_i]
      next if middle_rows.size.odd?

      first_half = middle_rows.take(middle_rows.size / 2)
      second_half = middle_rows.reverse.take(middle_rows.size / 2)
      next unless first_half == second_half

      first_rows = pattern[...i]
      last_rows = pattern[matching_row_i + 1..].reverse

      return i + first_half.size if first_rows.empty? || last_rows.empty?
    end
  end

  0
end

def calculate(text)
  patterns = text.split(/^\n/).map { |p| p.split("\n").map(&:chars) }

  result = nil
  patterns_count = patterns.size
  time = Benchmark.realtime do
    result = patterns.each_with_index.map do |pattern, index|
      puts "#{index}/#{patterns_count}"

      result_h = count_symmetry_horizontal(pattern)
      result_v = count_symmetry_horizontal(pattern.transpose)

      result_h * 100 + result_v
    end.sum
  end
  puts "Time: #{time} seconds"

  result
end

pp calculate(File.read(File.expand_path('./day13/input.txt')))

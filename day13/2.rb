require 'benchmark'

def count_symmetry_horizontal_smudge(pattern = [])
  pattern.each_with_index do |original_row, i|
    original_row.each_index do |smudge_i|
      smudge = case original_row[smudge_i]
               when '.'
                 '#'
               else
                 '.'
               end

      row = original_row.dup.fill(smudge, smudge_i, 1)

      pattern[i + 1..].each_with_index do |matching_row, matching_i|
        next unless matching_row == row

        matching_row_i = matching_i + i + 1

        middle_rows = pattern[i + 1..matching_row_i - 1]
        next if middle_rows.size.odd?

        first_half = middle_rows.take(middle_rows.size / 2)
        second_half = middle_rows.reverse.take(middle_rows.size / 2)
        next unless first_half == second_half

        first_rows = pattern[...i]
        last_rows = pattern[matching_row_i + 1..]

        shared_rows_size = [first_rows.size, last_rows.size].min

        if first_rows.reverse.take(shared_rows_size) == last_rows.take(shared_rows_size)
          return i + first_half.size + 1
        end
      end
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

      result_h = count_symmetry_horizontal_smudge(pattern)
      result_v = count_symmetry_horizontal_smudge(pattern.transpose)

      result_h * 100 + result_v
    end.sum
  end
  puts "Time: #{time} seconds"

  result
end

pp calculate(File.read(File.expand_path('./day13/input.txt')))

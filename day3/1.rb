def calculate(text)
  sum = 0
  current_number = ''
  adjacent_to_symbol = false

  all = text.split("\n").map(&:chars)
  size_i = all.size
  size_j = all.first.size

  all.each_with_index do |line, i|
    line.each_with_index do |char, j|
      case char
      when '0'..'9'
        current_number += char

        unless adjacent_to_symbol
          adjacent_to_symbol = check_adjacent?(all, i, j, size_i, size_j)
        end
      else
        if adjacent_to_symbol
          puts "sum + #{current_number} = #{sum + current_number.to_i}"
          sum += current_number.to_i
        else
          puts "discarding #{current_number}" if current_number != ''
        end

        current_number = ''
        adjacent_to_symbol = false
      end
    end
  end

  all
end

def check_adjacent?(all, i, j, size_i, size_j)
  [i - 1, i, i + 1].each do |ci|
    next if ci < 0 || ci >= size_i

    [j - 1, j, j + 1].each do |cj|
      next if cj < 0 || cj >= size_j

      case all[ci][cj]
      when '0'..'9', '.'
        next
      else
        puts "adjacent #{all[ci][cj]} at #{[ci, cj]}"
        return true
      end
    end
  end

  false
end
#
# calculate(
#   File.read(File.expand_path('./day3/test_input.txt'))
# )

calculate(
  File.read(File.expand_path('./day3/input.txt'))
)

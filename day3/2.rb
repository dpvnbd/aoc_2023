def calculate(text)
  all = text.split("\n").map(&:chars)
  size_i = all.size
  size_j = all.first.size

  sum = 0

  all.each_with_index do |line, i|
    line.each_with_index do |char, j|
      case char
      when '*'
        numbers = extract_adjacent_numbers(all, i, j, size_i, size_j)
        next unless numbers.size == 2

        sum += numbers[0] * numbers[1]
      else
        next
      end
    end
  end

  sum
end

def extract_adjacent_numbers(all, i, j, size_i, size_j)
  result = []

  # Left
  ci = i
  cj = j - 1
  digits = []
  loop do
    break if cj < 0

    break unless ('0'..'9').include?(all[ci][cj])
    digits.prepend(all[ci][cj])
    cj -= 1
  end

  unless digits.empty?
    puts "Adding #{digits.join.to_i} to result"
    result << digits.join.to_i
  end

  # Right
  ci = i
  cj = j + 1
  digits = []
  loop do
    break if cj >= size_j

    break unless ('0'..'9').include?(all[ci][cj])
    digits.append(all[ci][cj])
    cj += 1
  end

  unless digits.empty?
    puts "Adding #{digits.join.to_i} to result"
    result << digits.join.to_i
  end

  # Top
  ci = i - 1
  cj = j
  digits = []

  unless ci < 0
    if j > 0
      digits << all[ci][j]
    end

    # Top-left
    cj = j - 1
    loop do
      break if cj < 0

      break unless ('0'..'9').include?(all[ci][cj])
      digits.prepend(all[ci][cj])
      cj -= 1
    end

    # Top-right
    cj = j + 1
    loop do
      break if cj >= size_j

      break unless ('0'..'9').include?(all[ci][cj])
      digits.append(all[ci][cj])
      cj += 1
    end
  end

  top_digits = digits.join.strip.split('.').map(&:to_i).reject(&:zero?)
  unless top_digits.empty?
    puts "Adding #{top_digits} to result [#{ci}, #{cj}]"
    result += top_digits
  end

  # Bottom
  ci = i + 1
  cj = j
  digits = []

  unless ci >= size_i

    if j <= size_j &&
      digits << all[ci][j]
    end

    # bottom-left
    cj = j - 1
    loop do
      break if cj < 0

      break unless ('0'..'9').include?(all[ci][cj])
      digits.prepend(all[ci][cj])
      cj -= 1
    end

    # bottom-right
    cj = j + 1
    loop do
      break if cj >= size_j

      break unless ('0'..'9').include?(all[ci][cj])
      digits.append(all[ci][cj])
      cj += 1
    end
  end

  bottom_digits = digits.join.split('.').map(&:to_i).reject(&:zero?)
  unless bottom_digits.empty?
    puts "Adding #{bottom_digits} to result [#{ci}, #{cj}]"
    result += bottom_digits
  end

  result
end

pp calculate(
  File.read(File.expand_path('./day3/input.txt'))
)

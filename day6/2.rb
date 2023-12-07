def calculate(text)
  pair = text.split("\n").map { |line| line.gsub(/\D/, '').to_i }

  min_hold_time = (-pair[0] + Math.sqrt(pair[0] ** 2 - 4 * pair[1])) / -2
  max_hold_time = (-pair[0] - Math.sqrt(pair[0] ** 2 - 4 * pair[1])) / -2

  max_hold_time.ceil - min_hold_time.floor - 1
end

pp calculate(File.read(File.expand_path('./day6/input.txt')))

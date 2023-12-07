def calculate(text)
  lines = text.split("\n")
  times = lines.first.scan(/\d+/).map(&:to_i)
  distances = lines.last.scan(/\d+/).map(&:to_i)
  pairs = times.zip(distances)

  pairs.inject(1) do |result, pair|
    min_hold_time = (-pair[0] + Math.sqrt(pair[0] ** 2 - 4 * pair[1])) / -2
    max_hold_time = (-pair[0] - Math.sqrt(pair[0] ** 2 - 4 * pair[1])) / -2

    total_integers = max_hold_time.ceil - min_hold_time.floor - 1
    result * total_integers
  end
end

pp calculate(File.read(File.expand_path('./day6/input.txt')))

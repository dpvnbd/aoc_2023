def calculate(text)
  sequences = text.split("\n").map { |s| s.split(' ').map(&:to_i) }

  results = sequences.map do |sequence|
    extrapolate_backwards(sequence)
  end

  results.sum
end

def extrapolate_backwards(sequence)
  return 0 if sequence.all?(&:zero?)

  new_sequence = sequence[..sequence.size - 2].each_with_index.map do |left, left_index|
    sequence[left_index + 1] - left
  end

  (sequence.first - extrapolate_backwards(new_sequence))
end

pp calculate(File.read(File.expand_path('./day9/input.txt')))

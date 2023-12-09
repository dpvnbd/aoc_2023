def calculate(text)
  sequences = text.split("\n").map { |s| s.split(' ').map(&:to_i) }

  results = sequences.map do |sequence|
    result = extrapolate(sequence)
    result
  end

  results.sum
end

def extrapolate(sequence)
  return 0 if sequence.all?(&:zero?)

  new_sequence = sequence[..sequence.size - 2].each_with_index.map do |left, left_index|
    sequence[left_index + 1] - left
  end

  (sequence.last + extrapolate(new_sequence))
end

pp calculate(File.read(File.expand_path('./day9/input.txt')))

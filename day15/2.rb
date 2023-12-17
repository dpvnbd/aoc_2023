require 'benchmark'

def ascii_hash(string)
  value = 0

  string.chars.each do |c|
    value += c.ord
    value *= 17
    value %= 256
  end

  value
end

def apply_steps(steps)
  boxes = Array.new(256) { Hash.new }

  steps.each do |label, operation, value|
    box = boxes[ascii_hash(label)]

    case operation
    when '-'
      box.delete(label)
    when '='
      box[label] = value.to_i
    end
  end

  boxes
end

def count_power(boxes)
  sum = 0

  boxes.each_with_index do |box, box_i|
    box.values.each_with_index do |value, slot_i|
      sum += (box_i + 1) * (slot_i + 1) * value
    end
  end

  sum
end

def calculate(text)
  steps = text.split(',').map { |s| s.split(/\b/) }

  result = nil
  time = Benchmark.realtime do
    boxes = apply_steps(steps)
    result = count_power(boxes)
  end
  puts "Time: #{time} seconds"

  result
end

pp calculate(File.read(File.expand_path('./day15/input.txt')))

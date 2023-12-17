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

def calculate(text)
  strings = text.split(',')

  result = nil
  time = Benchmark.realtime do
    result = strings.map { |string| ascii_hash(string) }.sum
  end
  puts "Time: #{time} seconds"

  result
end

pp calculate(File.read(File.expand_path('./day15/input.txt')))

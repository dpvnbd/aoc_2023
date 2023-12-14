require 'benchmark'

SCALING = 5

@cache = {}
@cache_hits = 0
@total_operations = 0

# GOD LEFT ME UNFINISHED
def count_arrangement(springs, groups, running_count = 0)
  cache_key = "#{springs.join}/#{groups.join(',')}/#{running_count}"

  @total_operations += 1

  if @cache.key?(cache_key)
    @cache_hits += 1
    return @cache[cache_key]
  end

  springs.each_with_index do |s, i|
    case s
    when '#'
      running_count += 1
      if groups.empty?
        return 0
      elsif running_count > groups.first
        return 0
      end
    when '.'
      if running_count.zero?
        next
      elsif running_count != groups.first
        return 0
      elsif running_count == groups.first
        running_count = 0
        groups = groups[1..]
      end
    when '?'
      filled_count = count_arrangement(['#'] + springs[i + 1..], groups, running_count)
      empty_count = count_arrangement(['.'] + springs[i + 1..], groups, running_count)
      result = filled_count + empty_count

      @cache[cache_key] = result
      return filled_count + empty_count
    end
  end

  if groups == [running_count] || running_count.zero? && groups.empty?
    1
  else
    0
  end
end

def calculate(text)
  spring_rows = []
  broken_counts = []

  text.split("\n").each do |line|
    row = line.split(' ').first
    spring_rows << ([row] * SCALING).join('?').chars
    broken_counts << line.scan(/\d+/).map(&:to_i) * SCALING
  end

  size = spring_rows.size

  result = nil

  time = Benchmark.realtime do
    result = spring_rows.zip(broken_counts).each_with_index.map do |spring_counts, index|
      springs, counts = spring_counts
      puts "#{index}/#{size}"
      result = count_arrangement(springs, counts)
      result
    end
  end

  puts "Time: #{time} seconds"
  puts "Cache hits: #{(@cache_hits / @total_operations.to_f).truncate(2) * 100}%"
  result.sum
end

pp calculate(File.read(File.expand_path('./day12/input.txt')))

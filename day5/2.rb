require 'benchmark'

MAPS_REGEX = /.*map:\n([\d\s]*)\n*/
SEEDS_REGEX = /\Aseeds: (.*)\n/

def calculate(text)
  seed_ranges = []
  raw_seeds = text.match(SEEDS_REGEX)[1].split(' ').map(&:to_i)

  raw_seeds.each_slice(2) do |start, length|
    seed_ranges << (start..start + length)
  end

  maps = text.scan(MAPS_REGEX).flatten.map do |s|
    s.split("\n").map do |line|
      bounds = line.split(' ').map(&:to_i)
      source_range = (bounds[1]...bounds[1] + bounds[2])

      [source_range, bounds[0] - bounds[1]] # [mapped range, offset to mapped value]
    end
  end

  result = maps.inject(seed_ranges) do |previous_ranges, map|
    sorted_map = map.sort_by { |range, _offset| range.begin }

    mapped_ranges = []

    previous_ranges.each do |seed_range|
      current_begin = seed_range.begin

      # Skip to first relevant map
      map_index = sorted_map.index { |map_range, _offset| map_range.end >= seed_range.begin }

      loop do
        break if current_begin >= seed_range.end

        current_map, offset = if map_index
                                sorted_map[map_index]
                              else
                                [nil, nil]
                              end

        if current_map
          if current_map.cover?(current_begin)
            current_end = seed_range.end <= current_map.end ? seed_range.end : current_map.end
            mapped_ranges << (current_begin + offset...current_end + offset)
            map_index += 1
          else
            current_end = seed_range.end <= current_map.begin ? seed_range.end : current_map.begin
            mapped_ranges << (current_begin...current_end)
          end

          current_begin = current_end
        else
          next_map, _next_offset = if map_index
                                     sorted_map[map_index + 1]
                                   else
                                     [nil, nil]
                                   end

          unless next_map && !next_map.cover?(current_begin)
            current_end = next_map ? next_map.begin : seed_range.end
            mapped_ranges << (current_begin...current_end)
            break unless next_map

            current_begin = current_end
          end
        end
      end
    end

    mapped_ranges
  end

  result.sort_by(&:begin).first.begin
end

time = Benchmark.realtime do
  result = calculate(File.read(File.expand_path('./day5/input.txt')))
  puts "Result: #{result}"
end

puts "Time: #{time} seconds"

MAPS_REGEX = /.*map:\n([\d\s]*)\n*/
SEEDS_REGEX = /\Aseeds: (.*)\n/

def calculate(text)
  seeds = text.match(SEEDS_REGEX)[1].split(' ').map(&:to_i)

  maps = text.scan(MAPS_REGEX).flatten.map do |s|
    map = {}
    s.split("\n").map do |line|
      bounds = line.split(' ').map(&:to_i)
      source_range = (bounds[1]..bounds[1] + bounds[2])

      map[source_range] = bounds[0]
    end

    map
  end

  result = seeds.map do |seed|
    maps.inject(seed) do |result, map|
      covered_range = map.keys.detect { |range| range.cover?(result) }
      if covered_range
        result - covered_range.begin + map[covered_range]
      else
        result
      end
    end
  end

  result.min
end

pp calculate(File.read(File.expand_path('./day5/input.txt')))

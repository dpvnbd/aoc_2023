GAME_REGEX = /^Game (?<id>\d+): (?<set>.+)$/
TOTAL_CUBES = { 'red' => 12, 'green' => 13, 'blue' => 14 }

def parse_games(filename)
  text = File.read(filename)
  text.strip.split("\n").map do |line|
    matched_game = line.match(GAME_REGEX)

    moves = matched_game[:set].split('; ').map do |colors_set|
      set = []
      colors_set.scan(/(\d+) (red|green|blue)/) { |count, color| set << [color, count.to_i] }
      set.to_h
    end

    { id: matched_game[:id].to_i, moves: }
  end
end

def calculate(games, total_cubes)
  games.inject(0) do |result, game|
    is_possible = game[:moves].all? do |move|
      move.all? { |color, count| total_cubes[color] >= count }
    end
    if is_possible
      result + game[:id]
    else
      result
    end
  end
end

def calculate_min_power(games)
  powers = games.map do |game|
    min_required = { 'red' => 0, 'green' => 0, 'blue' => 0 }
    game[:moves].each do |move|
      move.each { |color, count| min_required[color] = count if count > min_required[color]  }
    end

    min_required.values.inject(:*)
  end

  powers.sum
end

games = parse_games(File.expand_path('./day2/input.txt'))

# games = parse_games(File.expand_path('./day2/test_input.txt'))

# pp games

# pp calculate(games, TOTAL_CUBES)

pp calculate_min_power(games)
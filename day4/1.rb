def calculate(text)
  cards = text.split("\n").map do |line|
    line.split(':').last.strip.split('|').map do |section|
      section.strip.split(/\s+/).map(&:to_i)
    end
  end

  scores = cards.map do |winning, available|
    count = available.inject(0) { |count, number| count + (winning.include?(number) ? 1 : 0) }

    next 0 if count.zero?

    2 ** (count - 1)
  end

  scores.sum
end

pp calculate(File.read(File.expand_path('./day4/input.txt')))

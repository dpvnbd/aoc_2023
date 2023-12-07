GAME_REGEX = /^Card\s+(?<card>\d+):\s+(?<winning>.+)\|\s+(?<available>.+)$/
Card = Struct.new('Card', :id, :winning, :available, :copies_count, :win_count)

def calculate(text)
  cards = text.split("\n").map do |line|
    card_match = line.match(GAME_REGEX)

    Card.new(
      id: card_match[:card].to_i,
      winning: card_match[:winning].strip.split(/\s+/).map(&:to_i),
      available: card_match[:available].strip.split(/\s+/).map(&:to_i),
      copies_count: 1
    )
  end

  cards.each_with_index do |card, index|
    card.win_count = winning_count(card)

    cards[index + 1, card.win_count].each do |copied_card|
      copied_card.copies_count += card.copies_count
    end
  end

  cards.sum(&:copies_count)
end

def winning_count(card)
  card.available.inject(0) { |count, number| count + (card.winning.include?(number) ? 1 : 0) }
end

pp calculate(File.read(File.expand_path('./day4/input.txt'))   )

class Hand
  include Comparable
  CARD_RANKS = %w[A K Q T 9 8 7 6 5 4 3 2 J].freeze

  HAND_RANKS = [
    [5], # 5 of a kind
    [1, 4], # 4 of a kind
    [2, 3], # full house
    [1, 1, 3], # 3 of a kind
    [1, 2, 2], # 2 pairs
    [1, 1, 1, 2], # 1 pair
    [1, 1, 1, 1, 1] # high card
  ].freeze
  attr_reader :cards_text, :bid

  def initialize(cards_text, bid)
    @cards_text = cards_text
    @bid = bid
  end

  def type_rank
    return @type_rank if @type_rank

    chars = cards_text.chars.uniq
    counts = chars.map { |c| cards_text.count(c) }
    char_counts = chars.zip(counts).to_h
    wildcard_count = char_counts.delete('J')
    counts = char_counts.values

    if wildcard_count == 5
      counts = [5]
    elsif wildcard_count
      max_count = counts.max
      max_index = counts.index(max_count)
      counts[max_index] = counts[max_index] + wildcard_count
    end

    @type_rank = HAND_RANKS.index(counts.sort)
  end

  def inspect
    "#{@cards_text} = #{type_rank}"
  end

  def <=>(other)
    if type_rank == other.type_rank
      cards_text.chars.zip(other.cards_text.chars).each do |card1, card2|
        next if card1 == card2

        return CARD_RANKS.index(card1) <=> CARD_RANKS.index(card2)
      end

      0
    else
      type_rank <=> other.type_rank
    end
  end
end

def calculate(text)
  hands_bids = text.scan(/^(\w{5}) (\d+)$/)
                   .flatten(0)
                   .to_h
                   .transform_values!(&:to_i)

  hands = hands_bids.map { |h, bid| Hand.new(h, bid) }.sort.reverse

  hands.each_with_index.map { |hand, index| hand.bid * (index + 1) }.sum
end

pp calculate(File.read(File.expand_path('./day7/input.txt')))

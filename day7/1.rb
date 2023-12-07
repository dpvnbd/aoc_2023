class Hand
  include Comparable
  CARD_RANKS = %w[A K Q J T 9 8 7 6 5 4 3 2].freeze
  HAND_RANKS = [
    /(.)\1{4}/, # five of a kind
    /(.)\1{3}/, # four of a kind
    /^(.)\1{1,2}(.)\2{1,2}$/, # full house
    /(.)\1{2}/, # three of a kind
    /(.)\1.*(.)\2/, # two pair
    /(.)\1/, # one pair
    /./, # high card
  ].freeze

  attr_reader :cards_text, :bid

  def initialize(cards_text, bid)
    @cards_text = cards_text
    @bid = bid
    @cards_sorted = cards_text.chars.sort.join
  end

  def type_rank
    @type_rank ||= HAND_RANKS.index { |regex| regex === @cards_sorted }
  end

  def inspect
    "#{@cards_text} = #{@cards_sorted} => #{type_rank}"
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

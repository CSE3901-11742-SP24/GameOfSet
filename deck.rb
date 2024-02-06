require_relative 'cards'

# Class representing a deck of cards
class Deck
  # Accessor for the cards in the deck
  attr_reader :cards

  # Initializes a new deck by generating and shuffling the cards
  def initialize
    @cards = generate_deck.shuffle
  end

  # Generates a deck of cards
  def generate_deck
    # Define possible attributes for cards
    numbers = [1, 2, 3]
    shapes = ['diamond', 'squiggle', 'oval']
    shadings = ['solid', 'striped', 'open']
    colors = ['red', 'green', 'purple']

    # Generate all possible combinations of attributes and create cards
    numbers.product(shapes, shadings, colors).map do |attrs|
      Card.new(*attrs) # Create a new card with the given attributes
    end
  end


  # Deals a specified number of cards from the deck
  def deal_cards(number)
    @cards.shift(number) # Remove and return the specified number of cards from the top of the deck
  end

  # Checks if the deck is empty
  def empty?
    return @cards.empty? # Return true if the deck has no cards, false otherwise
  end

  # Removes and returns the top card from the deck
  def shift
    @cards.shift # Remove and return the top card from the deck
  end
end

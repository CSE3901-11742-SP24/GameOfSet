require 'timeout'

# Card Class: Represents a single card in the game with attributes for number, shape, shading, and color.
class Card
  attr_accessor :number, :shape, :shading, :color

  # Initialization and to_s method for card representation
  def initialize(number, shape, shading, color)
    @number = number
    @shape = shape
    @shading = shading
    @color = color
  end
  
  # Method to represent the card as a string.
  def to_s
    "#{@number} #{@shape} #{@shading} #{@color}"
  end
end
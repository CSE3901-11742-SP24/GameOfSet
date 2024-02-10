# main.rb

# Load the logic.rb file which contains the SetGameSimulation class
require_relative 'logic'

# Array containing valid difficulties
valid_difficulties = [:easy, :medium, :hard]

# Variable to store the total number of cards in the deck
total_deck = nil


# Prompt the user to choose a difficulty level
puts "Choose difficulty (easy, medium, hard):"

# Get user input and convert it to symbol
selected_difficulty = gets.chomp.to_sym


# Loop until the user enters a valid difficulty
until valid_difficulties.include?(selected_difficulty)
  # Prompt the user to choose again with red text
  puts "\e[31mInvalid difficulty. Please choose again (easy, medium, hard):\e[0m" # Red text
  selected_difficulty = gets.chomp.to_sym
end

# Assign the total number of cards based on the selected difficulty
if selected_difficulty == :easy
  total_deck = 12
elsif selected_difficulty == :medium
  total_deck = 25
elsif selected_difficulty == :hard
  total_deck = 45
end

# Create an instance of SetGameSimulation with 1000 games and the total number of cards
simulation = SetGameSimulation.new(1000, total_deck) # 1000 games with 12 cards each

# Run the simulation
simulation.run_simulation

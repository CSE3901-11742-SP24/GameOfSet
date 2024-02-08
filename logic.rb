require 'timeout'
require_relative 'deck'

# SetGame Class: Manages the game logic including deck generation, dealing cards, player and computer turns, and checking for sets.
class SetGame
  attr_accessor :deck, :played_cards, :score, :computer_score, :total_turns, :total_sets_found, :cards_in_play, :difficulty

  # Initialization: Sets up the game based on difficulty and the number of cards in play.
  # generate_deck: Creates a full deck of unique cards.
  # deal_cards: Deals a specified number of cards to begin the game.
  # play_turn: Manages the player's turn, including input handling and set verification.
  # computer_turn: Simulates a turn for the computer, with varying behavior based on difficulty.
  # start_game: Initiates and runs the game loop until a game-over condition is met.
  # game_over?: Checks for the game-over condition.
  # print_all_valid_sets: (Optional debugging tool) Prints all valid sets currently available.
  # provide_hint: Offers a hint to the player upon request.
  # display_statistics: Shows game statistics after the game ends.
  # Private methods include utilities for checking sets, replacing cards, and validating player input.
  def initialize(cards_in_play = 12)
    @difficulty = difficulty
    @cards_in_play = cards_in_play
    @deck = Deck.new
    @played_cards = @deck.deal_cards(cards_in_play)
    @score = 0
    @computer_score = 0
    @total_turns = 0
    @total_sets_found = 0
  end

  # Player's turn method
  def play_turn
    begin
      Timeout::timeout(30) { # Timeout for player's turn
        puts "Select three cards by their indices (e.g., '0 5 7'), or type 'hint' for a hint:"
        input = gets.chomp

        if input.downcase == 'hint'
          provide_hint
        else
          indices = input.split.map(&:to_i)
          system("clear")
          if valid_indices?(indices) && indices.size == 3 # Checking for valid input
            @total_turns += 1
            if set?(indices.map { |index| @played_cards[index] }) # Checking for a set
              puts "Set found!"
              @score += 1
              @total_sets_found += 1
              replace_cards(indices)
            else
              puts "Not a set. Try again."
            end
          else
            puts "Invalid input. Try again."
          end
    
          puts "Your score: #{@score}"
          puts "Computer's score: #{@computer_score}"
        end
      }
    rescue Timeout::Error
      puts "Time's up! Move to next turn."
    end
  end

  # Computer's turn method
  def computer_turn
    @total_turns += 1
    if rand < 0.7  # 70% chance for the computer to attempt finding a set
      valid_sets = @played_cards.combination(3).select { |trio| set?(trio) }
      unless valid_sets.empty?
        chosen_set = valid_sets.sample
        puts "Computer found a set: #{chosen_set.map(&:to_s).join(', ')}"
        replace_cards(chosen_set.map { |card| @played_cards.index(card) })
        @computer_score += 1
        @total_sets_found += 1
      else
        puts "Computer could not find a set."
      end
    else
      puts "Computer missed this turn."
    end
  end  


  # Game loop
  def start_game
    until game_over?
      print_all_valid_sets
      play_turn # Human player's turn
      computer_turn # Computer player's turn
    end
    puts "Game over! Final scores - Player: #{@score}, Computer: #{@computer_score}"
    display_statistics
  end

  # Check for game over condition
  def game_over?
    @deck.empty? || !any_sets_available?
  end

  # Provide debugging tool to print all valid sets
  def print_all_valid_sets
    valid_sets = []

    puts "Current cards:"
    @played_cards.each_with_index do |card, index|
      puts "#{index}: #{card}"
    end

    @played_cards.combination(3).each do |trio|
      valid_sets << trio if set?(trio)
    end

    if valid_sets.empty?
      puts "No valid sets available."
    else
      valid_sets.each_with_index do |set, index|
        set_indices = set.map { |card| @played_cards.index(card) }
        
      end
    end
  end

  # Offer a hint to the player
  def provide_hint
    number_of_sets = @played_cards.combination(3).count { |trio| set?(trio) }
    if number_of_sets > 0
      puts "Hint: There are #{number_of_sets} sets available."
    else
      puts "No sets available. Reshuffling..."
      reshuffle_cards
    end
  end

  # Display game statistics
  def display_statistics
    puts "Total turns: #{@total_turns}"
    puts "Total sets found: #{@total_sets_found}"
    # Display other statistics as needed
  end
  
  private

  # Check if any sets are available
  def any_sets_available?
    @played_cards.combination(3).any? { |trio| set?(trio) }
  end

  # Validate indices entered by the player
  def valid_indices?(indices)
    indices.size == 3 && indices.uniq.size == 3 && indices.all? { |index| index.between?(0, @played_cards.size - 1) }
  end

  # Check if given cards form a set
  def set?(cards)
    return false if cards.length != 3
  
    attributes = cards.map { |card| [card.number, card.shape, card.shading, card.color] }
  
    attributes.transpose.all? do |attr|
      attr.uniq.length == 1 || attr.uniq.length == 3
    end
  end

  # Replace cards on the table
  def replace_cards(indices)
    indices.each do |index|
      @played_cards[index] = @deck.shift unless @deck.empty?
    end
  end
end

# SetGameSimulation Class: Used for running a specified number of game simulations to gather statistics.
class SetGameSimulation
  # Initialization: Sets up the simulation with the number of games and cards in play.
  # run_simulation: Executes the simulation, tracking occurrences of no set conditions.
  # calculate_statistics: Analyzes and displays results from the simulation.
  def initialize(games_to_simulate, cards_in_play)
    @games_to_simulate = games_to_simulate
    @cards_in_play = cards_in_play
  end

  # Run the simulation
  def run_simulation
    no_set_count = 0
    game = nil

    @games_to_simulate.times do
      game = SetGame.new(@cards_in_play)
      game.start_game
      no_set_count += 1
    end

    calculate_statistics(no_set_count)
  end

  def calculate_statistics(no_set_count)
    probability_no_set = no_set_count.to_f / @games_to_simulate
    puts "Probability of no set with #{@cards_in_play} cards: #{probability_no_set}"
  end
end

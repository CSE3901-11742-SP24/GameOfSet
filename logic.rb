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


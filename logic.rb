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


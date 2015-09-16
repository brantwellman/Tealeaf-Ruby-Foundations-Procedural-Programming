VALID_CHOICES = %w(rock paper scissors lizard spock)

def prompt(message)
  puts("=> #{message}")
end

def choice_selection(first_letter)
  case first_letter
  when 'r'
    "rock"
  when 'p'
    "paper"
  when 's'
    "scissors"
  when 'l'
    "lizard"
  when 'sp'
    "spock"
  end
end

def win?(first, second)
  (first == 'rock' && second == 'scissors') ||
    (first == 'rock' && second == 'lizard') ||
    (first == 'lizard' && second == 'spock') ||
    (first == 'lizard' && second == 'paper') ||
    (first == 'spock' && second == 'scissors') ||
    (first == 'spock' && second == 'rock') ||
    (first == 'paper' && second == 'rock') ||
    (first == 'paper' && second == 'spock') ||
    (first == 'scissors' && second == 'paper') ||
    (first == 'scissors' && second == 'lizard')
end

def display_result(player, computer)
  if win?(player, computer)
    prompt("You won!")
    return "player"
  elsif win?(computer, player)
    prompt("Computer won!")
    return "computer"
  else
    prompt("It is a tie!")
  end
end

# def wins_tracker(player, computer)
#   player_wins = 0
#   computer_wins = 0
#   if win?(player, computer)
#     player_wins = player_wins + 1
#     prompt("Your score is: #{player_wins}")
#   elsif win?(computer, player)
#     computer_wins = computer_wins + 1
#     prompt("The computer's score is: #{computer_wins}.")
#   end
# end

loop do
  choice = ''
  # player_wins = 0
  # computer_wins = 0
  # while (player_wins < 5 || computer_wins < 5) do
    loop do
      prompt("Choose one: #{VALID_CHOICES.join(', ')}")
      prompt("Type r - rock, p - paper, s - scissors, l - lizard, sp - spock")
      first_letter = gets.chomp
      choice = choice_selection(first_letter)

      if VALID_CHOICES.include?(choice)
        break
      else
        prompt("That's not a valid choice.")
      end
    end

    computer_choice = VALID_CHOICES.sample

    prompt("You chose: #{choice}. The computer chose: #{computer_choice}.")

    display_result(choice, computer_choice)

    # wins_tracker(choice, computer_choice)
    # prompt("Your score is: #{player_wins}.")
    # prompt("The computer's score is: #{computer_wins}")

    prompt("Do you want to play again?")
    break unless gets.chomp.downcase.start_with?('y')
  end
# end

prompt("Thanks for playing. Buh-Bye!")

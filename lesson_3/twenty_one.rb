require 'pry'

def prompt(message)
  puts "=> #{message} <="
end

def initialize_deck
  suits = ['C', 'D', 'H', 'S']
  values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  values.product(suits).shuffle
end

def deal_card(deck, hand)
  hand << deck.pop
end

def display_cards(dealer_hand, player_hand)
  prompt "The Dealer has: a #{dealer_hand[0][0]} and the hole card (unknown)."
  prompt "You have a #{player_hand[0][0]} and a #{player_hand[1][0]}"
end

def total(hand)
  values = hand.map { |card| card[0] }

  sum = 0
  values.each do |value|
    if value == 'A'
      sum += 11
    elsif value.to_i == 0
      sum += 10
    else
      sum += value.to_i
    end
  end

  if sum > 21
    values.select { |v| v == 'A' }.count.times do
      sum -=10
    end
  end
  sum
end

def busted?(hand)
  total(hand) > 21
end

# def player_turn(deck, player_hand)
#   answer = ''
#   loop do
#     prompt "Would you like to Hit (H) or Stay (S)? Please enter one."
#     answer = gets.chomp.downcase
#     if !answer.start_with?('s', 'h')
#       prompt "That was an improper response."
#     elsif answer.start_with?('h')
#       deal_card(deck, player_hand)
#       prompt "You were dealt a #{player_hand.last[0]}."
#       prompt "Your total is #{total(player_hand)}"
#         if busted?(player_hand)
#          prompt "You busted. The Dealer wins. :("
#          break
#          return
#        end
#     else
#       break
#     end
#   end
# end

# def dealer_turn(deck, dealer_hand)
  # prompt "The Dealer has a #{dealer_hand[0][0]} and the hole card is a #{dealer_hand[1][0]}."
  # loop do
  #   if total(dealer_hand) >= 17
  #     prompt "The dealer stays."
  #     break
  #   else
  #     deal_card(deck, dealer_hand)
  #     prompt "The Dealer dealt himself a #{dealer_hand.last[0]}."
  #     prompt "The Dealer's total is #{total(dealer_hand)}."
  #     if busted?(dealer_hand)
  #       prompt "The Dealer busted. You win!"
  #       break
  #     end
  #   end
  # end
# end

def result?(dealer_hand, player_hand)
  player_total = total(player_hand)
  dealer_total = total(dealer_hand)

  if player_total > 21
    :player_busted
  elsif dealer_total > 21
    :dealer_busted
  elsif dealer_total >= player_total
    :dealer
  elsif player_total > dealer_total
    :player
  end
end

def display_winner(dealer_hand, player_hand)
  result = result?(dealer_hand, player_hand)

  case result
  when :player_busted
    prompt "You busted. Dealer wins."
  when :dealer_busted
    prompt "The Dealer busted. You win!"
  when :dealer
    prompt "Your total is #{total(player_hand)} and the Dealer's total is #{total(dealer_hand)}.  Sorry, the dealer won."
  when :player
    "Your total is #{total(player_hand)} and the Dealer's total is #{total(dealer_hand)}. You win!"
  end
end

def play_again?
  prompt "Do you want to play again? (y or n)"
  gets.chomp.downcase.start_with?('y')
end

prompt "Welcome to my fancy dancy game of Twenty-one!"

loop do

  player_cards = []
  dealer_cards = []
  new_deck = initialize_deck

  2.times do
    deal_card(new_deck, player_cards)
    deal_card(new_deck, dealer_cards)
  end

  display_cards(dealer_cards, player_cards)

  # player_turn(new_deck, player_cards)
  loop do
    answer = ''
    loop do
      prompt "Would you like to Hit (H) or Stay (S)? Please enter one."
      answer = gets.chomp.downcase
      break if ['h', 's'].include?(answer)
      prompt "That was an improper response."
    end

    if answer == 'h'
      deal_card(new_deck, player_cards)
      prompt "You chose to hit."
      prompt "You were dealt a #{player_cards.last[0]}."
      prompt "Your total is #{total(player_cards)}"
    end

    break if answer == 's' || busted?(player_cards)
  end

  if busted?(player_cards)
    display_winner(dealer_cards, player_cards)
    play_again? ? next : break
  else
    prompt "You stayed and your total is #{total(player_cards)}"
  end

  # dealer_turn(new_deck, dealer_cards)
  prompt "Now its the Dealer's turn..."
  prompt "The Dealer has a #{dealer_cards[0][0]} and the hole card is a #{dealer_cards[1][0]}."
  loop do
    break if busted?(dealer_cards) || total(dealer_cards) >= 17
    prompt "The Dealer hits"
    deal_card(new_deck, dealer_cards)
    prompt "The Dealer dealt himself a #{dealer_cards.last[0]}."
    prompt "The Dealer's total is #{total(dealer_cards)}."
  end

  if busted?(dealer_cards)
    display_winner(dealer_cards, player_cards)
    play_again? ? next : break
  else
    prompt "Dealer stays and his total is #{total(dealer_cards)}"
  end

  prompt "Both have stayed."
  prompt "The Player's total is #{total(player_cards)}."
  prompt "The Dealer's total is #{total(dealer_cards)}."
  display_winner(dealer_cards, player_cards)

  break unless play_again?
end

prompt "Thanks for playing my fancy dancy game of Twenty-one!"

require 'pry'

def prompt(message)
  puts "=> #{message} <="
end

def initialize_deck
  suits = ['C', 'D', 'H', 'S']
  values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  values.product(suits)
end

def deal_initial_cards(deck, dealer_hand, player_hand)
  player_hand << deck.shuffle!.pop
  dealer_hand << deck.shuffle!.pop
  player_hand << deck.shuffle!.pop
  dealer_hand << deck.shuffle!.pop
  return deck
end

def deal_card(deck, hand)
  hand << deck.shuffle!.pop
  return deck
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

def player_win?(dealer_hand, player_hand)
  total(player_hand) > total(dealer_hand)
end

def display_winner(dealer_hand, player_hand)
  if player_win?(dealer_hand, player_hand)
    prompt "Your total is #{total(player_hand)} and the Dealer's total is #{total(dealer_hand)}. You win!"
  else
    prompt "Your total is #{total(player_hand)} and the Dealer's total is #{total(dealer_hand)}.  Sorry, the dealer won."
  end
end


prompt "Welcome to my fancy dancy game of Twenty-one!"

player_cards = []
dealer_cards = []


new_deck = initialize_deck

deal_initial_cards(new_deck, player_cards, dealer_cards)

display_cards(dealer_cards, player_cards)

# player_turn(new_deck, player_cards)

answer = ''
loop do
  prompt "Would you like to Hit (H) or Stay (S)? Please enter one."
  answer = gets.chomp.downcase
  if !answer.start_with?('s', 'h')
    prompt "That was an improper response."
  elsif answer.start_with?('h')
    deal_card(new_deck, player_cards)
    prompt "You were dealt a #{player_cards.last[0]}."
    prompt "Your total is #{total(player_cards)}"
      if busted?(player_cards)
       prompt "You busted. The Dealer wins. :("
       break
       return
     end
  else
    break
  end
end

return if busted?(player_cards)


# dealer_turn(new_deck, dealer_cards)

prompt "The Dealer has a #{dealer_cards[0][0]} and the hole card is a #{dealer_cards[1][0]}."
loop do
  if total(dealer_cards) >= 17
    prompt "The dealer stays."
    break
  else
    deal_card(new_deck, dealer_cards)
    prompt "The Dealer dealt himself a #{dealer_cards.last[0]}."
    prompt "The Dealer's total is #{total(dealer_cards)}."
    if busted?(dealer_cards)
      prompt "The Dealer busted. You win!"
      break
      return
    end
  end
end

player_win?(dealer_cards, player_cards)

display_winner(dealer_cards, player_cards)

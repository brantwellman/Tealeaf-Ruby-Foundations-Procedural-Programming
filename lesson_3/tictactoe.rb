require 'pry'

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                [[1, 5, 9], [3, 5, 7]]              # diagonals
INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'

def prompt(msg)
  puts "=> #{msg}"
end

def joinor(array, spacer, word = 'or')
  array[-1] = "#{word} #{array.last}" if array.size > 1
  array.join(spacer)
end

def choose_first_player(current_player)
  prompt "Who would you like to go first?"
  loop do
    prompt "Please enter 'C' for Computer, 'P' for Player, or 'R for Random'."
    answer = gets.chomp.downcase
    if answer == 'r'
      random_choice = ['p', 'c'].sample
      current_player << random_choice
    else
      current_player << answer
    end
    break if current_player.any? { |i| ['c', 'p', 'r'].include? i }
    prompt "That was not a proper selection"
  end
end

def alternate_player(current_player)
  if current_player.last == 'c'
    current_player << 'p'
  elsif current_player.last == 'p'
    current_player << 'c'
  end
end

def display_board(brd)
  system 'clear'
  puts "Player is a #{PLAYER_MARKER}. Computer is a #{COMPUTER_MARKER}."
  puts ""
  puts "     |     |     "
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |     "
  puts "-----+-----+-----"
  puts "     |     |     "
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |     "
  puts "-----+-----+-----"
  puts "     |     |     "
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |     "
  puts ""
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def place_piece!(brd, current_player)
  if current_player.last == 'p'
    # player moves
    square = ''
    loop do
      prompt("Choose a square (#{joinor(empty_squares(brd), ', ')}):")
      square = gets.chomp.to_i
      break if empty_squares(brd).include?(square)
      prompt("Sorry, that's not a valid choice.")
    end
    brd[square] = PLAYER_MARKER
  elsif current_player.last == 'c'
    # computer moves
    square = nil

    # winning move
    WINNING_LINES.each do |line|
      square = find_potential_wins(line, brd, COMPUTER_MARKER)
      break if square
    end

    # blocking move
    if !square
      WINNING_LINES.each do |line|
        square = find_potential_wins(line, brd, PLAYER_MARKER)
        break if square
      end
    end

    # middle square move
    if !square
      if empty_squares(brd).include?(5)
        square = 5
      end
    end

    # random move
    if !square
      square = empty_squares(brd).sample
    end
    brd[square] = COMPUTER_MARKER
    display_board(brd)
  end
end

def find_potential_wins(line, brd, marker)
  if brd.values_at(*line).count(marker) == 2
    brd.select { |k, v| line.include?(k) && v == INITIAL_MARKER }.keys.first
  else
    nil
  end
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(line[0], line[1], line[2]).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(line[0], line[1], line[2]).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def win_tracker(brd, player_wins, computer_wins)
  if detect_winner(brd) == 'Player'
    player_wins << '1'
  elsif detect_winner(brd) == 'Computer'
    computer_wins << '1'
  end
end

player_wins = []
computer_wins = []
current_player = []

loop do
  board = initialize_board
  puts board.inspect
  choose_first_player(current_player)
  loop do
    display_board(board)
    place_piece!(board, current_player)
    current_player = alternate_player(current_player)
    break if someone_won?(board) || board_full?(board)
  end

  display_board(board)

  if someone_won?(board)
    prompt "#{detect_winner(board)} won!"
  else
    prompt "It's a tie!"
  end

  win_tracker(board, player_wins, computer_wins)
  prompt "The score is Player: #{player_wins.size} and Computer: #{computer_wins.size}."

  break if player_wins.size == 5 || computer_wins.size == 5

  prompt "Play again? (y or n)"
  break unless gets.chomp.downcase.start_with?('y')
end

prompt "Thanks for playing Tic Tac Toe. See you later!"

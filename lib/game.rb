require 'pry'

class Game
  attr_accessor :board, :player_1, :player_2

  WIN_COMBINATIONS =
  [[0, 1, 2], [3, 4, 5], [6, 7, 8], #HORIZONTAL WIN
    [0, 3, 6], [1, 4, 7], [2, 5, 8], #VERTICAL WIN
    [0, 4, 8], [6, 4, 2]] #DIAGONAL WIN

  def initialize (player_1 = Players::Human.new("X"), player_2 = Players::Human.new("O"), board = Board.new)
    @board = board
    @player_1 = player_1
    @player_2 = player_2
  end

  def start #CLI 0, 1, 2 players. X starts.
    binding.pry
   puts "Welcome to Tic Tac Toe! Enter the number of players you would like to have: 0, 1, or 2:"
     input = gets.to_i
   case input
     when 0
       self.computer
     when 1
       self.computerhuman
     when 2
       self.humanhuman
     else
       start
     end
   end

 def computer
     puts "Enjoy the game between 2 Computers"
     @player_1 = Computer.new("X")
     @player_1.board = self.board
     @player_2 = Computer.new("O")
     @player_2.board = self.board
     self.play
     self.again?
 end

 def computerhuman
   puts "Select your token: X or O."
   input = gets.chomp.upcase
   if input == "X"
     @player_2 = Computer.new("O")
     @player_2.board = self.board
   elsif input == "O"
     @player_1 = Computer.new("X")
     @player_1.board = self.board
   else
     self.start
   end
     self.play
     self.again?
 end

 def humanhuman
   self.play
   self.again?
 end 

 def again?
  if over?
   puts "Would you like to play again? Type y or n."
   input = gets.chomp.downcase
     if input ==  "y"
       self.board.reset!
       self.start
     elsif input == "n"
       return "Good bye"
       exit
     else again?
     end
   end
 end

  def current_player #Returns correct player (X = 3rd move). 1st move is X, 2nd is O,...Need to determine which turn (turn_count) to be able to determine the current player (refer to the method I just created in the board class).Self.board.turn_count => this will return the number of turns only!!Even == 1st player and odd == second player!
    @board.turn_count.odd? ? player_2 : player_1
  end

  def won? #Draw? = False ELSE Won? Winning Combo (WINNNING COMBINATIONS)
    WIN_COMBINATIONS.detect do |win| #Detect or find
      win.all?{|x| @board.cells[x] == "X"} || #.all? returns T if each block never returns false or nil. Comparing the WIN_COMBINATIONS to the board.cells
      win.all?{|o| @board.cells[o] == "O"}
    end
  end

  def draw? #not won and full (cannot keep playing)
    !won? && @board.full?
  end

  def over? #draw or won
    if draw? || won?
      return true
    else
      false
    end
  end

  def winner #X if X, o if O, nil if none. Need to use won? as helper method to determine first IF the game is won. Then need to return the player token.
      winner = self.won?
      winner ? @board.cells[winner[0]] : nil
  end

  def turn
    puts "#{current_player}'s turn." #Allows each Turn to take in both players (each get 1 turn)
      input = current_player.move(board).to_i #input is set to the current_play (either 1 or 2) and his/her move(board) method which is defined in the player file. This is "gets" as a string. Convert to an integer bc the valid_move method compares integers.
    if board.valid_move?(input.to_s) #now that it is an integer, we can compare it, and then change it back into a string. if valid, the board will update (calling the update method)
      board.update(input, current_player) #if it is not a valid move (position taken or number given outside of range 1-9) then it will tell the user to input answer again and continue to loop through that UNTIl they give a valid_move
    elsif !board.valid_move?(input.to_s)
     puts "Invalid move. Try again"
     turn
    end
  end

  def play
    while !over?
      turn
    end
    if won?
      puts "Congratulations #{winner}!"
    elsif draw?
      puts "Cat's Game!"
    end
  end
end

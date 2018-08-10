module Players
  class Computer < Player #Like the Human class, also going to be initialized with a token, either "X" or "O"
    def move(board)
      valid_moves = "1".."9"
      valid_moves.to_a.sample #.rand ? need a random number to be seleted
    end
  end
end

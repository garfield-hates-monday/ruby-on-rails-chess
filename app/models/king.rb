class King < Piece

  def valid_move?(x, y)

    if (x_difference(x) <= 1) && (y_difference(y) <= 1) && (x_difference(x) + y_difference(y) > 0) 
      return true
    else
      return false
    end
  end

  def possible_moves
   [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, 1], [-1, -1], [1, -1]]
  end
end
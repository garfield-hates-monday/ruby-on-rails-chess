class Rook < Piece
  
  def valid_move?(x,y)
    if x_difference(x) >= 1 && y_difference(y) == 0 || y_difference(y) >= 1 && x_difference(x) == 0
      return true
    else
      return false
    end
  end

end
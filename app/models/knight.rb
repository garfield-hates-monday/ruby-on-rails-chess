class Knight < Piece

  def valid_move?(x,y)
    if  x_difference(x) == 2 && y_difference(y) == 1 || y_difference(y) == 2 && x_difference(x) == 1
      return true
    else
      return false
    end
  end

end
class Bishop < Piece

  def valid_move?(x, y)
    if x_difference(x) == y_difference(y)
      return true
    else
      return false
    end
  end
end
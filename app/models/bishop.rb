class Bishop < Piece

  def valid_move?(x, y)
    x_difference(x) == y_difference(y)
  end
end
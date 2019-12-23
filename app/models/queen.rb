class Queen < Piece

  def valid_move?(x, y)
    x_position == x || y_position == y || x_difference(x) == y_difference(y)
  end

end
class Rook < Piece
  def valid_move?(x,y)
    x_difference = x_difference(x)
    y_difference = y_difference(y)

    (x_difference >= 1 && y_difference == 0) || (y_difference >= 1 && x_difference == 0)
  end
end
class King < Piece

  def valid_move?(x, y)
    x_difference = ( x - x_position ).abs
    y_difference = (y - y_position ).abs

    if (x_difference <= 1) && (y_difference <= 1)
      return true
    else
      return false
    end
  end

end
class Knight < Piece


  def is_obstructed?(new_x, new_y)
    #Keep empty. Knight cannot be obstructed
  end
  
  def valid_move?(x,y)
    if  x_difference(x) == 2 && y_difference(y) == 1 || y_difference(y) == 2 && x_difference(x) == 1
      return true
    else
      return false
    end
  end

end
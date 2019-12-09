class Pawn < Piece
  attr_accessor :on_initial_square, :color
  

  def valid_move?(x,y)
    if @on_initial_square && x_difference(x) == 0 && y_difference(y) == 2
      return true
    elsif !@on_initial_square && x_difference(x) == 0 && y_difference(y) == 1
      return true
    else 
      return false
    end


  end

end
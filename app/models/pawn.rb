class Pawn < Piece
  attr_accessor :on_initial_square, :color
  

  def valid_move?(x,y)
    x_distance = ( x - x_position ).abs
    y_distance = (y - y_position ).abs
    if en_passant?(x, y)
      return true 
    #black diagonal capture
    elsif (x_distance == y_distance) && !white? && is_obsturcted?(x, y, id, color)
      y == y_coord + 1
    #white diagonal capture
    elsif (x_distance == y_distance) && white? && is_obsturcted?(x, y, id, color)
      new_y_coord == y_coord - 1
    #black starting position (move 2)
    elsif y_coord == 2 && black? && !is_obsturcted?(x, y, id, color)
      x_distance == 0 && (y == 3 || y == 4)
    #white starting position (move 2)
    elsif y_coord == 7 && white? && !is_obsturcted?(x, y, id, color)
      x_distance == 0 && (y == 6 || y == 5)
    #black post initial move
    elsif !white? && !is_obsturcted?(x, y, id, color)
      (x_distance == 0) && (x == (y + 1))
    #white post initial move
    elsif white? && !is_obsturcted?(x, y, id, color)
      (x_distance == 0) && (new_y_coord == (y_coord - 1))
    else
      false
    end
  end





  def en_passant?(new_x_position, new_y_position)
    return false unless ((new_y_position == y_position + 1 && !white?) || (new_y_position == y_position - 1 && white?)) && ((new_x_coord == x_coord + 1) || (new_x_coord == x_coord - 1)) && ((new_y_coord == 3 && white?) || (new_y_coord == 6 && !white?))
    other_piece = game.pieces.where(y_position: y_position, x_position: new_x_position, type: "Pawn").first
    return false if other_piece.nil? || other_piece.move_number != 1
    return true
  end

  def pawn_promotion?
    pawn = game.pieces.where(:type =>"Pawn").where(:user_id => game.turn_user_id)[0]
    (y_coord == 8 && !white?) || (y_coord == 1 && white?) #black pawn white baseline or white pawn black baseline
  end
end
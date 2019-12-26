class Pawn < Piece

  def valid_move?(x,y)
    if en_passant?(x, y)
      return true 
    #black diagonal capture
    elsif y == capture && x_difference(x) == y_difference(y) && !white? && occupied?(x,y)
      return true
    #white diagonal capture
    elsif y == capture && x_difference(x) == y_difference(y) && white? && occupied?(x,y)
      return true
    #black starting position (move 2)
    elsif y_position == 2 && !white? && !is_obstructed?(x, y) && y == (self.y_position + 2) && x_difference(x) == 0
      return true
    #white starting position (move 2)
    elsif y_position == 7 && white? && !is_obstructed?(x, y) && y == (self.y_position - 2) && x_difference(x) == 0
      return true
    #black post initial move
    elsif !white? && !is_obstructed?(x, y) && x_difference(x) == 0 && y == (self.y_position + 1)
      return true
    #white post initial move
    elsif white? && !is_obstructed?(x, y) && x_difference(x) == 0 && y == (self.y_position - 1)
      return true
    else
      return false
    end
  end

  def capture
    if white?
      y_position - 1
    else
      y_position + 1
    end
  end

  def en_passant?(new_x_position, new_y_position)
    return false unless ((new_y_position == (y_position + 1) && !white?) || (new_y_position == (y_position - 1) && white?)) && new_x_position == (x_position + 1) || new_x_position == (x_position - 1) && new_y_position == 3 && white? || new_y_position == 6 && !white?
    other_piece = game.pieces.where(y_position: y_position, x_position: new_x_position, type: "Pawn").first
    return false if other_piece.nil? || other_piece.move_number != 1
    return true
  end

  def pawn_promotion?
    pawn = game.pieces.where(:type =>"Pawn").where(:user_id => game.turn_user_id)[0]
    (y_position == 8 && !white?) || (y_position == 1 && white?) #black pawn white baseline or white pawn black baseline
  end
end
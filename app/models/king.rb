class King < Piece

  def valid_move?(x, y)

    if (x_difference(x) <= 1) && (y_difference(y) <= 1) && (x_difference(x) + y_difference(y) > 0) 
      return true
    elsif castle_legal?(x, y)
      return true
    else
      return false
    end
  end

  def castle_kingside_legal?(x, y) #checks to make sure moving kingside is allowed
    return false if self.moves > 0
    return false if !rook_at(8, y)
    return false if occupied?(7, y)
    return false if is_obstructed?(8, white? ? 8 : 1)
    return true if x == 7
    false
  end

  def castle_queenside_legal?(x, y) #checks to make sure moving queenside is allowed
    return false if self.moves > 0
    return false if !rook_at(1, y)
    return false if occupied?(3, y)
    return false if is_obstructed?(1, white? ? 8 : 1)
    return true if x == 3
    false
  end

  def castle_legal?(x, y)
    return true if castle_kingside_legal?(x, y) || castle_queenside_legal?(x, y)
    false
  end
  def white?
    if self.color == "white"
      return true
    else
      return false
    end
  end
end
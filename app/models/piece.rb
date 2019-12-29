class Piece < ApplicationRecord
  belongs_to :game

  def valid_move?(x, y)
    #this method is implemented by the individual piece
  end

  def is_obstructed?(new_x, new_y)
    direction = move_direction(new_x, new_y)
    if direction == 'horizontal'
      if new_x > self.x_position
        (self.x_position + 1).upto(new_x - 1) do |x_current|
          return true if occupied?(x_current, self.y_position)
        end
      else
        (self.x_position - 1).downto(new_x + 1) do |x_current|
          return true if occupied?(x_current, self.y_position)
        end
      end
    elsif direction == 'vertical'
      if new_y > self.y_position
        (self.y_position + 1).upto(new_y - 1) do |y_current|
          return true if occupied?(self.x_position, y_current)
        end
      else
        (self.y_position - 1).downto(new_y + 1) do |y_current|
          return true if occupied?(self.x_position, y_current)
        end
      end
    elsif direction == 'diagonal'
      if new_x > self.x_position && new_y > self.y_position
        (self.x_position + 1).upto(new_x - 1) do |x_current|
          y_current = self.y_position + (x_current - self.x_position)
          return true if occupied?(x_current, y_current)
        end
      elsif new_x < self.x_position && new_y > self.y_position
        (self.x_position - 1).downto(new_x + 1) do |x_current|
          y_current = self.y_position + (x_current - self.x_position).abs
          return true if occupied?(x_current, y_current)
        end
      elsif new_x > self.x_position && new_y < self.y_position
        (self.x_position + 1).upto(new_x - 1) do |x_current|
          y_current = self.y_position - (x_current - self.x_position)
          return true if occupied?(x_current, y_current)
        end
      else
        (self.x_position - 1).downto(new_x + 1) do |x_current|
          y_current = self.y_position - (x_current - self.x_position).abs
          return true if occupied?(x_current, y_current)
        end
      end
    end
    false
  end

  def move_direction(new_x, new_y)
    return 'horizontal' if self.x_position != new_x && self.y_position == new_y
    return 'vertical' if  self.x_position == new_x && self.y_position != new_y
    return 'diagonal' if (new_x - self.x_position).abs == (new_y - self.y_position).abs
    false
  end

  def occupied?(x_current, y_current)
    board_space = game.pieces.find_by(x_position: x_current, y_position: y_current)
    board_space.present?
  end

  def x_difference(x)
    x_difference = (x_position - x).abs
  end

  def y_difference(y)
    y_difference = (y_position - y).abs
  end

  def can_move_to?(x,y)
    return false if is_obstructed?(x, y) == true
    return false if valid_move?(x, y) == false
    true
  end

  def move_to!(x, y)
    return false if valid_move?(x, y) == false
    opposing_piece = game.pieces.find_by(x_position: x, y_position: y)
    
    if opposing_piece.present? && opposing_piece.color != self.color
      opposing_piece.update_attributes(x_position: nil, y_position: nil, captured: true)
    elsif opposing_piece.present?
      return false
    end
    
    if self.type == "Pawn" && self.en_passant?(x,y) == true
      opposing_pawn = game.pieces.find_by(:x_position => x, :y_position => self.y_position, :type => "Pawn")
      opposing_pawn.update_attributes(x_position: nil, y_position: nil, captured: true)
    end
    
    self.transaction do
      self.update_attributes(x_position: x, y_position: y)
      self.increment!(:moves)
      if game.check?(self.color)
        fail ActiveRecord::Rollback
        return false
      end
    end
   
    if castling_queenside?(x, y) == true 
     rook = game.pieces.find_by(x_position: 1, y_position: y, type: "Rook")
     rook.update_attributes(x_position: 4, y_position: y)
     rook.increment!(:moves)
    end
    if castling_kingside?(x, y) == true
      rook = game.pieces.find_by(x_position: 8, y_position: y, type: "Rook")
      rook.update_attributes(x_position: 6, y_position: y)
      rook.increment!(:moves)
    end
  end

  def castling_queenside?(x, y) #tests to see if king is castling towards queenside
    return true if game.pieces.where(x_position: 3, y_position: y, type: "King").present? && rook_at(1, y)
  end

  def castling_kingside?(x, y) #tests to see if king is castling towards kingside
    return true if game.pieces.where(x_position: 7, y_position: y, type: "King").present? && rook_at(8, y)
  end
  
  def rook_at(x,y) #sees if there is a rook there that hasnt moved
    game.pieces.where(:x_position => x, :y_position => y, :type => "Rook", :moves => 0).present?
  end

  def capturable?(color)
    piece_being_checked = game.pieces.find_by(x_position: self.x_position, y_position: self.y_position)
    enemy_pieces = game.pieces.where.not(color: color, x_position: nil, y_position: nil)
    enemy_pieces.any? { |piece| piece.can_move_to?(piece_being_checked.x_position, piece_being_checked.y_position) }
  end
  
  def white?
    if self.color == "white"
      return true
    else
      return false
    end
  end

end

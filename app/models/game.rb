class Game < ApplicationRecord
  belongs_to :black_user, class_name: 'User', foreign_key: 'black_user_id', optional: true
  belongs_to :white_user, class_name: 'User', foreign_key: 'white_user_id', optional: true
  has_many :pieces, dependent: :destroy
  after_create :populate_game
  after_rollback :check_yourself_error
  


  def reset_pieces_player
    pieces.where(color: "black").update_all(user_id: black_user_id)
    pieces.where(color: "white").update_all(user_id: white_user_id)
  end

  def populate_game
    # WHITE PIECES
      # Pawns
      (1..8).each do |x_position|
        Pawn.create(game_id: self.id, color: 'white', x_position: x_position, y_position: 7, user_id: white_user_id)
      end

      # Rooks
      [1, 8].each do |x_position|
        Rook.create(game_id: id, color: 'white', x_position: x_position, y_position: 8, user_id: white_user_id)
      end

      # Knights
      [2, 7].each do |x_position|
        Knight.create(game_id: id, color: 'white', x_position: x_position, y_position: 8, user_id: white_user_id)
      end

      #Bishops
      [3, 6].each do |x_position|
        Bishop.create(game_id: id, color: 'white', x_position: x_position, y_position: 8, user_id: white_user_id)
      end

      #King
      King.create(game_id: id, color: 'white', x_position: 5, y_position: 8, user_id: white_user_id)

      #Queen
      Queen.create(game_id: id, color: 'white', x_position: 4, y_position: 8, user_id: white_user_id)

    # BLACK PIECES
      # Pawns
      (1..8).each do |x_position|
        Pawn.create(game_id: id, color: 'black', x_position: x_position, y_position: 2, user_id: black_user_id)
      end

      # Rooks
      [1, 8].each do |x_position|
        Rook.create(game_id: id, color: 'black', x_position: x_position, y_position: 1, user_id: black_user_id)
      end

      # Knights
      [2, 7].each do |x_position|
        Knight.create(game_id: id, color: 'black', x_position: x_position, y_position: 1, user_id: black_user_id)
      end

      #Bishops
      [3, 6].each do |x_position|
        Bishop.create(game_id: id, color: 'black', x_position: x_position, y_position: 1, user_id: black_user_id)
      end

      #King
      King.create(game_id: id, color: 'black', x_position: 5, y_position: 1, user_id: black_user_id)

      #Queen
      Queen.create(game_id: id, color: 'black', x_position: 4, y_position: 1, user_id: black_user_id)
  end

  def white_player
    User.find_by_id(white_user_id)
  end

  def black_player
    User.find_by_id(black_user_id)
  end

  def pieces_remaining(color)
    self.pieces.where(color: color, x_position: !nil, y_position: !nil)
  end

  def check?(color)
    king = pieces.find_by(type: "King", color: color)
    enemy_pieces = self.pieces.where.not(color: color, x_position: nil, y_position: nil)
    enemy_pieces.each do |piece|
      if piece.can_move_to?(king.x_position, king.y_position)
        @piece_checking_king = piece
        return true
      end
    end
    return false
  end

  def checkmate?(color)
    king_in_check = pieces.find_by(type: "King", color: color)
    original_x = king_in_check.x_position
    original_y = king_in_check.y_position
    escape_moves = []
    return false unless check?(color)
    enemy_pieces = self.pieces.where.not(color: color, x_position: nil, y_position: nil)
    enemy_pieces.each do |piece|
      if piece.can_move_to?(king_in_check.x_position, king_in_check.y_position)
        @piece_checking_king = piece
      end
    end
    return false if @piece_checking_king.capturable?(@piece_checking_king.color)
    king_in_check.possible_moves.each do |move|
      king_in_check.move_to!(king_in_check.x_position + move[0], king_in_check.y_position + move[1])
      king_in_check.reload
      if king_in_check.x_position != original_x && king_in_check.y_position != original_y && king_in_check.x_position > 0 && king_in_check.y_position > 0
        escape_moves << move
      end
      king_in_check.update_attributes(x_position: original_x, y_position: original_y)
    end
    return false if escape_moves.any?
    return false if @piece_checking_king.can_be_obstructed?(king_in_check)
    true
  end

  def check_yourself_error
    flash[:warning] = "This move will put your King in check!"
  end
  
end


class Game < ApplicationRecord
  belongs_to :user, optional: true
  has_many :pieces, dependent: :destroy
  after_create :populate_game

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

  def check?(color)
    king = pieces.find_by(type: 'King', color: color)
    enemy_pieces = pieces_remaining(!color)

    enemy_pieces.each do |piece|
      if piece.valid_move?(king.x_position, king.y_position)
        return true
        else
        return false
      end
    end
  end

 def pieces_remaining(color)
  pieces.includes(:game).where(
    "color = ?") and (color)
  end



  
end


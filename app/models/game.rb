class Game < ApplicationRecord
  belongs_to :black_user, class_name: 'User', foreign_key: 'black_user_id', optional: true
  belongs_to :white_user, class_name: 'User', foreign_key: 'white_user_id', optional: true
  has_many :pieces, dependent: :destroy
  after_create :populate_game

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
    self.pieces.where(color: "#{color}", x_position: !nil, y_position: !nil)
  end

  def check?(color)
    king = pieces.find_by(type: "King", color: color)
    enemy_pieces = self.pieces.where.not(color: color, x_position: nil, y_position: nil)
    enemy_pieces.any?{ |piece| piece.can_move_to?(king.x_position, king.y_position) }
  end
  
end


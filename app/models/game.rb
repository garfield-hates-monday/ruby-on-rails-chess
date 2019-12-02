class Game < ApplicationRecord
  has_many :pieces, :dependent => :destroy
  after_create :populate_game

  def populate_game
    # WHITE PIECES
      # Pawns
      (1..8).each do |x_position|
        Pawn.create(game_id: self.id, color: 'white', x_position: x_position, y_position: 7, user_id: white_user_id, type: 'pawn')
      end

      # Rooks
      [1, 8].each do |x_position|
        Rook.create(game_id: id, color: 'white', x_position: x_position, y_position: 8, user_id: white_user_id, type: "rook")
      end

      # Knights
      [2, 7].each do |x_position|
        Knight.create(game_id: id, color: 'white', x_position: x_position, y_position: 8, user_id: white_user_id, type: "knight")
      end

      #Bishops
      [3, 6].each do |x_position|
        Bishop.create(game_id: id, color: 'white', x_position: x_position, y_position: 8, user_id: white_user_id, type: "bishop")
      end

      #King
      King.create(game_id: id, color: 'white', x_position: 5, y_position: 8, user_id: white_user_id, type: "king")

      #Queen
      Queen.create(game_id: id, color: 'white', x_position: 4, y_position: 8, user_id: white_user_id, type: "queen")

    # BLACK PIECES
      # Pawns
      (1..8).each do |x_position|
        Pawn.create(game_id: id, color: 'black', x_position: x_position, y_position: 2, user_id: black_user_id, type: "pawn")
      end

      # Rooks
      [1, 8].each do |x_position|
        Rook.create(game_id: id, color: 'black', x_position: x_position, y_position: 1, user_id: black_user_id, type: "rook")
      end

      # Knights
      [2, 7].each do |x_position|
        Knight.create(game_id: id, color: 'black', x_position: x_position, y_position: 1, user_id: black_user_id, type: "knight")
      end

      #Bishops
      [3, 6].each do |x_position|
        Bishop.create(game_id: id, color: 'black', x_position: x_position, y_position: 1, user_id: black_user_id, type: "bishop")
      end

      #King
      King.create(game_id: id, color: 'black', x_position: 5, y_position: 1, user_id: black_user_id, type: "king")

      #Queen
      Queen.create(game_id: id, color: 'black', x_position: 4, y_position: 1, user_id: black_user_id, type: "queen")
  end

  def white_player
    User.find_by_id(white_user_id)
  end

  def black_player
    User.find_by_id(black_user_id)
  end
end


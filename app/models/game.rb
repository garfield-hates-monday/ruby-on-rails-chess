class Game < ApplicationRecord
  validates :name, presence: true
  has_many :pieces
  after_create :populate_game!

  def populate_game!
    #white pieces
    (1..8).each do |i|
      Pawn.create(game_id: id, x_position: i, y_position: 2, color: "white")
    end

    Rook.create(game_id: id, x_position: 1 , y_position: 1, color: "white")
    Rook.create(game_id: id, x_position: 8, y_position: 1, color: "white")

    Knight.create(game_id: id, x_position: 2, y_position: 1, color: "white")
    Knight.create(game_id: id, x_position: 7, y_position: 1, color: "white")

    Bishop.create(game_id: id, x_position: 3, y_position: 1, color: "white")
    Bishop.create(game_id: id, x_position: 6, y_position: 1, color: "white")

    Queen.create(game_id: id, x_position: 5, y_position: 1, color: "white")
    King.create(game_id: id, x_position: 4, y_position: 1, color: "white")

    #black pieces
    (1..8).each do |i|
      Pawn.create(game_id: id, x_position: i, y_position: 7, color: "black")
    end

    Rook.create(game_id: id, x_position: 1 , y_position: 8, color: "black")
    Rook.create(game_id: id, x_position: 8, y_position: 8, color: "black")

    Knight.create(game_id: id, x_position: 2, y_position: 8, color: "black")
    Knight.create(game_id: id, x_position: 7, y_position: 8, color: "black")

    Bishop.create(game_id: id, x_position: 3, y_position: 8, color: "black")
    Bishop.create(game_id: id, x_position: 6, y_position: 8, color: "black")

    Queen.create(game_id: id, x_position: 4, y_position: 8, color: "black")
    King.create(game_id: id, x_position: 5, y_position: 8, color: "black")
  end

end

require 'rails_helper'

  RSpec.describe Game, type: :model do
    describe 'check?' do
      it "should return true for rook to put king in check" do
        game = Game.create
        king = game.pieces.find_by(type: "King", color: "black")
        king.update_attributes(x_position: 4, y_position: 4)
        rook = Rook.create(game_id: game.id, x_position: 6, y_position: 4, color: "white")
        expect(game.check?("black")).to eq true
      end 

      it "should return false if a piece is obstructing the king" do
        game = Game.create
        king = game.pieces.find_by(type: "King", color: "black")
        king.update_attributes(x_position: 4, y_position: 4)
        rook = Rook.create(game_id: game.id, x_position: 6, y_position: 4, color: "white")
        blocking_pawn = Pawn.create(game_id: game.id, x_position: 5, y_position: 4, color: "white")
        expect(game.check?("black")).to eq false
      end
    end
  end



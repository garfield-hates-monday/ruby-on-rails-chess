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

    describe 'checkmate' do
      it "should return false for rook and bishop to put king in checkmate" do
        game = Game.create
        king = game.pieces.find_by(type: "King", color: "black")
        king.update_attributes(x_position: 4, y_position: 4)
        rook = Rook.create(game_id: game.id, x_position: 3, y_position: 6, color: "white")
        second_rook = Rook.create(game_id: game.id, x_position: 5, y_position: 2, color: "white")
        bishop = Bishop.create(game_id: game.id, x_position: 5, y_position: 6, color: "white")
        second_bishop = Bishop.create(game_id: game.id, x_position: 3, y_position: 2, color: "white")
        expect(game.checkmate("black")).to eq false
      end
    end
  end



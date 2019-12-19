require 'rails_helper'

  RSpec.describe Game, type: :model do
    describe 'check?' do
      it "should return true for rook to put king in check" do
        game = Game.create
        King.create(x_position: 0, y_position: 7, color: "white")
        Rook.create(x_position: 2, y_position: 7, color: "black")
        expect(game.check?("white")).to eq true
      end 
    end
  end



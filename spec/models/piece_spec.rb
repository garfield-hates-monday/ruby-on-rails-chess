require 'rails_helper'

RSpec.describe Piece, type: :model do
  describe "King" do
    it "King.create should create a new King piece" do
      king = King.create
      expect(king.valid?).to eq true
    end

    it "should return true for a valid move" do
     king = King.create( :x_position => 4, :y_position => 1, :color => "white" )
     expect(king.valid_move?(5, 2)).to eq true
    end

    it "should return false for an invalid move" do
      king = King.create( :x_position => 4, :y_position => 1, :color => "white" )
      expect(king.valid_move?(9,9)).to eq false
    end
  end
end

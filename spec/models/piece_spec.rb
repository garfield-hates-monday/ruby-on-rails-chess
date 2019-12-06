require 'rails_helper'

RSpec.describe Piece, type: :model do
  describe "King" do
    let(:game) { Game.create!(name: "Test Game" ) }
    let(:king) { King.create!( game: game, :x_position => 4, :y_position => 1, :color => "white" ) }
    it "King.create should create a new King piece" do
      expect(king.valid?).to eq true
    end

    it "should return true for a valid move" do
     expect(king.valid_move?(5, 2)).to eq true
    end

    it "should return false for an invalid move" do
      expect(king.valid_move?(9,9)).to eq false
    end
  end
    
   describe '#move_to!' do
    let(:game) { Game.create! }
    let(:piece) { Piece.create!(x_position: 0, y_position: 0, game: game, color: 'white') }
    it 'should be able to move to coordinate' do
      piece.move_to!(1, 1)

      expect(piece.y_position).to eq(1)
      expect(piece.x_position).to eq(1)
    end
   
    it 'should be able to capture opposing piece' do
      opposing_piece = Piece.create!(x_position: 0, y_position: 1, game: game, color: 'black')

      piece.move_to!(0, 1)
      opposing_piece.reload
      expect(piece.y_position).to eq(1)
      expect(opposing_piece.y_position).to be_nil
      expect(opposing_piece.x_position).to be_nil
    end

    it 'should update position to new location' do
      piece.move_to!(2, 2)

      expect(piece.x_position).to eq(2)
      expect(piece.y_position).to eq(2)
    end

    it 'should not allow you to move to a coordinate where another of your pieces are' do
      same_color_piece = Piece.create!(x_position: 0, y_position: 1, game: game, color: 'white')
      piece.move_to!(0, 1)

      expect(same_color_piece.y_position).to eq(1)
      expect(piece.x_position).to eq(0)
      expect(piece.y_position).to eq(0)
    end
  end
end

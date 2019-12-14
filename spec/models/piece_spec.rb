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
  describe 'valid_move?' do
    let(:game) { Game.create! }

    let(:bishop) { Bishop.create( x_position: 3, y_position: 8, color: "white" ) }

    it "bishop should return true for a valid move" do
      expect(bishop.valid_move?(5, 6)).to eq true
    end

    it "bishop should return true for a valid move" do
      expect(bishop.valid_move?(1, 6)).to eq true
    end

    it "bishop should return false for an invalid move" do
      expect(bishop.valid_move?(0, 0)).to eq false
    end
    
    let(:queen) { Queen.create(x_position: 4, y_position: 8, color: 'white') }

    it "queen should return true for a valid horizontal move" do
      expect(queen.valid_move?(5, 8)).to eq true
    end

    it "queen should return true for a valid diagonal move" do
      expect(queen.valid_move?(5, 7)).to eq true
    end

    it "queen should return true for a valid verticle move" do
      expect(queen.valid_move?(4, 7)).to eq true
    end

    it "queen should return false for an invalid move" do
      expect(queen.valid_move?(6, 7)).to eq false
    end

    it "knight should return true for a valid move" do
      knight = Knight.create( :x_position => 2, :y_position => 1, :color => "white" )
      expect(knight.valid_move?(3, 3)).to eq true
    end

    it "knight should return true for a valid move" do
      knight = Knight.create( :x_position => 4, :y_position => 4, :color => "white" )
      expect(knight.valid_move?(6, 3)).to eq true
    end

    it "knight should return false for an invalid move" do
      knight = Knight.create( :x_position => 2, :y_position => 1, :color => "white" )
      expect(knight.valid_move?(3,2)).to eq false
    end

    it "rook should return true for a valid move" do
      rook = Rook.create( :x_position => 2, :y_position => 0, :color => "white" )
      expect(rook.valid_move?(2,8)).to eq true
    end

    it "rook should return false for an invalid move" do
      rook = Rook.create( :x_position => 2, :y_position => 0, :color => "white" )
      expect(rook.valid_move?(1,7)).to eq false
    end
  end
end

require 'rails_helper'

RSpec.describe Piece, type: :model do

  describe "Pawn moves" do
    it "should allow you to move two spots on opening space" do
      game = Game.create
      game.pieces.destroy_all
      white_pawn = game.pieces.create(x_position: 2, y_position: 7, color: "white", type: "Pawn")
      black_pawn = game.pieces.create(x_position: 3, y_position: 2, color: "black", type: "Pawn")
      expect(white_pawn.valid_move?(2,5)).to eq(true)
      expect(black_pawn.valid_move?(3,4)).to eq(true)
    end

    it "shouldn't allow you to move two spots if not on opening space" do
      game = Game.create
      game.pieces.destroy_all
      white_pawn = game.pieces.create(x_position: 2, y_position: 6, color: "white", type: "Pawn")
      black_pawn = game.pieces.create(x_position: 3, y_position: 3, color: "black", type: "Pawn")
      expect(white_pawn.valid_move?(2,4)).to eq(false)
      expect(black_pawn.valid_move?(3,5)).to eq(false)
    end

    it "should allow you to move diagonal if there is an opposing_piece" do
      game = Game.create
      game.pieces.destroy_all
      white_pawn = game.pieces.create(x_position: 2, y_position: 6, color: "white", type: "Pawn")
      black_pawn = game.pieces.create(x_position: 3, y_position: 5, color: "black", type: "Pawn")
      expect(white_pawn.valid_move?(3,5)).to eq(true)
      expect(black_pawn.valid_move?(2,6)).to eq(true)
    end
    it "shouldn't allow you to move diagonal if there is not an opposing_piece" do
      game = Game.create
      game.pieces.destroy_all
      white_pawn = game.pieces.create(x_position: 2, y_position: 6, color: "white", type: "Pawn")
      black_pawn = game.pieces.create(x_position: 3, y_position: 5, color: "black", type: "Pawn")
      expect(white_pawn.valid_move?(1,5)).to eq(false)
      expect(black_pawn.valid_move?(4,6)).to eq(false)
    end
    it "shouldn't allow you to move backwards" do
      game = Game.create
      game.pieces.destroy_all
      white_pawn = game.pieces.create(x_position: 2, y_position: 6, color: "white", type: "Pawn")
      black_pawn = game.pieces.create(x_position: 3, y_position: 5, color: "black", type: "Pawn")
      expect(white_pawn.valid_move?(2,7)).to eq(false)
      expect(black_pawn.valid_move?(3,4)).to eq(false)
    end
    it "shouldn't allow you to move forward if there is a piece there" do
      game = Game.create
      game.pieces.destroy_all
      white_pawn = game.pieces.create(x_position: 2, y_position: 6, color: "white", type: "Pawn")
      black_pawn = game.pieces.create(x_position: 2, y_position: 5, color: "black", type: "Pawn")
      expect(white_pawn.valid_move?(2,5)).to eq(false)
      expect(black_pawn.valid_move?(3,6)).to eq(false)
    end
    it "should allow you to do en passant if opposing piece only has 1 move" do
      game = Game.create
      game.pieces.destroy_all
      white_pawn = game.pieces.create(x_position: 4, y_position: 4, color: "white", type: "Pawn", moves: 2)
      black_pawn = game.pieces.create(x_position: 3, y_position: 4, color: "black", type: "Pawn", moves: 1)
      expect(white_pawn.valid_move?(3,3)).to eq(true)
      white_pawn.move_to!(3,3)
      white_pawn.reload
      black_pawn.reload
      expect(black_pawn.captured).to eq(true)
    end
    it "shouldn't allow you to do en passant if opposing piece only has 1 move" do
      game = Game.create
      game.pieces.destroy_all
      white_pawn = game.pieces.create(x_position: 4, y_position: 4, color: "white", type: "Pawn", moves: 2)
      black_pawn = game.pieces.create(x_position: 3, y_position: 4, color: "black", type: "Pawn", moves: 2)
      expect(white_pawn.valid_move?(3,3)).to eq(false)
    end
  end


  describe "castling" do
    it "should allow a white piece to kingside castle" do
      game = Game.create
      game.pieces.destroy_all
      left_rook = game.pieces.create(x_position: 1, y_position: 8, color: "white", type: "Rook")
      white_king = game.pieces.create(x_position: 5, y_position: 8, color: "white", type: "King")
      right_rook = game.pieces.create(x_position: 8, y_position: 8, color: "white", type: "Rook")
      white_king.move_to!(7,8)
      white_king.reload
      right_rook.reload
      left_rook.reload
      expect(white_king.x_position).to eq(7)
      expect(white_king.y_position).to eq(8)
      expect(right_rook.x_position).to eq(6)
      expect(right_rook.y_position).to eq(8)
      expect(left_rook.x_position).to eq(1)
      expect(left_rook.y_position).to eq(8)
    end

    it "should allow a white piece to queenside castle" do
      game = Game.create
      game.pieces.destroy_all
      left_rook = game.pieces.create(x_position: 1, y_position: 8, color: "white", type: "Rook")
      white_king = game.pieces.create(x_position: 5, y_position: 8, color: "white", type: "King")
      right_rook = game.pieces.create(x_position: 8, y_position: 8, color: "white", type: "Rook")
      white_king.move_to!(3,8)
      white_king.reload
      right_rook.reload
      left_rook.reload
      expect(white_king.x_position).to eq(3)
      expect(white_king.y_position).to eq(8)
      expect(right_rook.x_position).to eq(8)
      expect(right_rook.y_position).to eq(8)
      expect(left_rook.x_position).to eq(4)
      expect(left_rook.y_position).to eq(8)
    end

    it "should not allow a piece to castle if it is obstructed" do
      game = Game.create
      white_king = game.pieces.find_by(x_position: 5, y_position: 8, type: "King")
      black_king = game.pieces.find_by(x_position: 5, y_position: 1, type: "King")
      expect(white_king.castle_legal?(3,8)).to eq false
      expect(white_king.castle_legal?(7,8)).to eq false
      expect(black_king.castle_legal?(3,1)).to eq false
      expect(black_king.castle_legal?(7,1)).to eq false
    end

    it "should not allow a King to castle if it has moved" do
      game = Game.create
      game.pieces.destroy_all
      left_rook = game.pieces.create(x_position: 1, y_position: 8, color: "white", type: "Rook")
      white_king = game.pieces.create(x_position: 5, y_position: 8, color: "white", type: "King", moves: 2)
      right_rook = game.pieces.create(x_position: 8, y_position: 8, color: "white", type: "Rook")
      expect(white_king.castle_legal?(3,8)).to eq false
      expect(white_king.castle_legal?(7,8)).to eq false
    end

    it "should not allow a King to castle if the rook has moved" do
      game = Game.create
      game.pieces.destroy_all
      left_rook = game.pieces.create(x_position: 1, y_position: 8, color: "white", type: "Rook", moves: 2)
      white_king = game.pieces.create(x_position: 5, y_position: 8, color: "white", type: "King")
      right_rook = game.pieces.create(x_position: 8, y_position: 8, color: "white", type: "Rook", moves: 2)
      expect(white_king.castle_legal?(3,8)).to eq false
      expect(white_king.castle_legal?(7,8)).to eq false
    end

    # it "should not allow a King to castle if a space it is crossing is being attacked by an opposing piece" do
    #   game = Game.create
    #   game.pieces.destroy_all
    #   left_rook = game.pieces.create(x_position: 1, y_position: 8, color: "white", type: "Rook")
    #   white_king = game.pieces.create(x_position: 5, y_position: 8, color: "white", type: "King")
    #   right_rook = game.pieces.create(x_position: 8, y_position: 8, color: "white", type: "Rook")
    #   black_rook1 = game.pieces.create(x_position: 6, y_position: 1, color: "black", type: "Rook")
    #   black_rook2 = game.pieces.create(x_position: 4, y_position: 1, color: "black", type: "Rook")
    #   expect(white_king.castle_legal?(3,8)).to eq false
    #   expect(white_king.castle_legal?(7,8)).to eq false
    # end
    
    it "should allow a black piece to kingside castle" do
      game = Game.create
      game.pieces.destroy_all
      left_rook = game.pieces.create(x_position: 1, y_position: 1, color: "black", type: "Rook")
      black_king = game.pieces.create(x_position: 5, y_position: 1, color: "black", type: "King")
      right_rook = game.pieces.create(x_position: 8, y_position: 1, color: "black", type: "Rook")
      black_king.move_to!(7,1)
      black_king.reload
      right_rook.reload
      left_rook.reload
      expect(black_king.x_position).to eq(7)
      expect(black_king.y_position).to eq(1)
      expect(right_rook.x_position).to eq(6)
      expect(right_rook.y_position).to eq(1)
      expect(left_rook.x_position).to eq(1)
      expect(left_rook.y_position).to eq(1)
    end

    it "should allow a black piece to queenside castle" do
      game = Game.create
      game.pieces.destroy_all
      left_rook = game.pieces.create(x_position: 1, y_position: 1, color: "black", type: "Rook")
      black_king = game.pieces.create(x_position: 5, y_position: 1, color: "black", type: "King")
      right_rook = game.pieces.create(x_position: 8, y_position: 1, color: "black", type: "Rook")
      black_king.move_to!(3,1)
      black_king.reload
      right_rook.reload
      left_rook.reload
      expect(black_king.x_position).to eq(3)
      expect(black_king.y_position).to eq(1)
      expect(right_rook.x_position).to eq(8)
      expect(right_rook.y_position).to eq(1)
      expect(left_rook.x_position).to eq(4)
      expect(left_rook.y_position).to eq(1)
    end
  end
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

  describe 'is_obstructed?' do
  
    it "should return true when a piece is obstructed vertically" do
      game = Game.create
      white_rook = game.pieces.find_by(x_position: 1, y_position: 8)
      black_rook = game.pieces.find_by(x_position: 8, y_position: 1)
      white_queen = game.pieces.find_by(x_position: 4, y_position: 8)
      expect(white_rook.is_obstructed?(1,6)).to eq true
      expect(black_rook.is_obstructed?(8,3)).to eq true
      expect(white_queen.is_obstructed?(4,6)).to eq true
    end

    it "should return true when a piece is obstructed horizontally" do
      game = Game.create
      white_rook = game.pieces.find_by(x_position: 1, y_position: 8)
      black_rook = game.pieces.find_by(x_position: 8, y_position: 1)
      white_rook.update_attributes(x_position: 3, y_position: 4)
      black_rook.update_attributes(x_position: 5, y_position: 4)
      expect(white_rook.is_obstructed?(6,4)).to eq true
      expect(black_rook.is_obstructed?(2,4)).to eq true
    end

    it "should return true when a piece is obstructed diagonally" do
      game = Game.create
      white_queen = game.pieces.find_by(x_position: 4, y_position: 8)
      black_queen = game.pieces.find_by(x_position: 4, y_position: 1)
      white_queen.update_attributes(x_position: 3, y_position: 5)
      black_queen.update_attributes(x_position: 4, y_position: 4)
      expect(white_queen.is_obstructed?(5,3)).to eq true
      expect(black_queen.is_obstructed?(2,6)).to eq true
    end

    it "should return false when a piece is not obstructed" do
      game = Game.create
      white_queen = game.pieces.find_by(x_position: 4, y_position: 8)
      black_queen = game.pieces.find_by(x_position: 4, y_position: 1)
      white_queen.update_attributes(x_position: 3, y_position: 6)
      black_queen.update_attributes(x_position: 6, y_position: 3)
      expect(white_queen.is_obstructed?(1,6)).to eq false
      expect(white_queen.is_obstructed?(5,6)).to eq false
      expect(white_queen.is_obstructed?(5,4)).to eq false
      expect(white_queen.is_obstructed?(1,4)).to eq false
      expect(white_queen.is_obstructed?(3,4)).to eq false
      expect(black_queen.is_obstructed?(6,5)).to eq false
      expect(black_queen.is_obstructed?(4,5)).to eq false
      expect(black_queen.is_obstructed?(8,5)).to eq false
      expect(black_queen.is_obstructed?(4,3)).to eq false
      expect(black_queen.is_obstructed?(4,8)).to eq false
    end
  end
end

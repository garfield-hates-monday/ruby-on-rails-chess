class PiecesController < ApplicationController

  def show
    @piece = Piece.find_by_id(params[:id])
    @game = @piece.game
    @pieces = @game.pieces.all
  end

  def update
    @piece = Piece.find_by_id(params[:id])
    @game = @piece.game
    @piece.move_to!(x_position, y_position)
    redirect_to game_url(@game)
  end
end

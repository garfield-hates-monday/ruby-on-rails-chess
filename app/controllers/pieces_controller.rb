class PiecesController < ApplicationController

  def show
    @piece = Piece.find_by_id(params[:id])
    @game = @piece.game
    @pieces = @game.pieces.all
  end

  def update
    @piece = Piece.find(params[:id])
    @game = @piece.game
    if @piece.valid_move?(params[:x_position].to_i, params[:y_position].to_i) == false
      flash[:warning] = "Invalid move!"
    else
      @piece.move_to!(params[:x_position].to_i, params[:y_position].to_i)
    end
    redirect_to game_url(@game)
  end

  private

  def piece_params
    params.permit(:x_position, :y_position, :type)
  end
end




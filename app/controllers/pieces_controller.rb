class PiecesController < ApplicationController

  def show
    @piece = Piece.find_by_id(params[:id])
    @game = @piece.game
    @pieces = @game.pieces.all
  end

  def update
    @piece = Piece.find(params[:id])
    @game = @piece.game
    if @piece.is_obstructed?(params[:x_position].to_i, params[:y_position].to_i) == true
      flash[:warning] = "Invalid move! Your piece is obstructed!"
    elsif @piece.valid_move?(params[:x_position].to_i, params[:y_position].to_i) == false
      flash[:warning] = "Invalid move! Your piece can't move in this way!"
    else
      @piece.move_to!(params[:x_position].to_i, params[:y_position].to_i)
      flash[:success] = "#{@piece.color.capitalize} #{@piece.type} moved to (#{@piece.x_position}, #{@piece.y_position})"
    end
    redirect_to game_url(@game)
  end

  private

  def piece_params
    params.permit(:x_position, :y_position, :type)
  end
end




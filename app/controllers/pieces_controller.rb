class PiecesController < ApplicationController

  def show
    @piece = Piece.find_by_id(params[:id])
    @game = @piece.game
    @pieces = @game.pieces.all
  end

  def update
    @piece = Piece.find(params[:id])
    @game = @piece.game

    #if @piece.user_id != @game.turn
    #  flash[:error] = 'It is not your turn!'
    #elsif @piece.user_id != current_user.id
    #  flash[:error] = 'Invalid move, not your piece. Try another move.'
    if @piece.valid_move?(params[:x_position].to_i, params[:y_position].to_i) == false
      flash[:warning] = "Invalid move!"
    \
    else
      @piece.move_to!(params[:x_position].to_i, params[:y_position].to_i)
      flash[:success] = "#{@piece.color.capitalize} #{@piece.type} moved to (#{@piece.x_position}, #{@piece.y_position})"
      turn_update
      move_update
    end
    redirect_to game_url(@game)
  end

  def correct_turn?
    current_user.id == @game.turn
  end

  private

  def turn_update
    @piece = Piece.find(params[:id])
    @game = @piece.game
    if @piece.color == "white"
      @game.update_attributes(turn: @game.black_user_id)
    else
      @game.update_attributes(turn: @game.white_user_id)
    end
  end

  def move_update
    @piece = Piece.find(params[:id])
    @piece.increment!(:moves)
  end

  def piece_params
    params.permit(:x_position, :y_position, :type, :moves)
  end
end




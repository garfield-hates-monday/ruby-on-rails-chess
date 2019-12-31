class PiecesController < ApplicationController

  def show
    @piece = Piece.find_by_id(params[:id])
    @game = @piece.game
    @pieces = @game.pieces.all
  end

  def update
    @piece = Piece.find(params[:id])
    @game = @piece.game
    @original_x = @piece.x_position
    @original_y = @piece.y_position

    if @piece.user_id != current_user.id
      flash[:error] = 'Invalid move, not your piece. Try another move.'
    elsif @piece.user_id != @game.turn
      flash[:error] = 'It is not your turn!'
    elsif @piece.is_obstructed?(params[:x_position].to_i, params[:y_position].to_i) == true
      flash[:warning] = "Invalid move! Your piece is obstructed!"
    elsif @piece.valid_move?(params[:x_position].to_i, params[:y_position].to_i) == false
      flash[:warning] = "Invalid move! Your piece can't move in this way!"
    else
      @piece.move_to!(params[:x_position].to_i, params[:y_position].to_i)
      @piece.reload
      if @piece.x_position == @original_x && @piece.y_position == @original_y
        flash[:warning] = "This move will put your piece in check!"
      else
        flash[:success] = "#{@piece.color.capitalize} #{@piece.type} moved to (#{@piece.x_position}, #{@piece.y_position})"
        turn_update
      end
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

  def piece_params
    params.permit(:x_position, :y_position, :type, :moves)
  end
end




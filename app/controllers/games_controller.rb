class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :index, :update, :destroy, :forfeit]

  def new
    @game = Game.new
  end

  def show
    @game = Game.find_by_id(params[:id])
    @pieces = @game.pieces.all
    return render_not_found if @game.blank?
    if @game.check?("black") == true && @game.checkmate?("black") == true
      flash.now[:warning] = "Checkmate! White wins!"
    elsif @game.check?("black") == true
      flash.now[:warning] = "Black is in check!"
    end
    if @game.check?("white") == true && @game.checkmate?("white") == true
      flash.now[:warning] = "Checkmate! Black wins!"
    elsif @game.check?("white") == true
      flash.now[:warning] = "White is in check!"
    end
  end

  def create
    @game = Game.create(game_params.merge(white_user_id: current_user.id, turn: current_user.id))
    @game.save

    if @game.valid?
      redirect_to game_path(@game)
    else
      render :new, status: :unprocessable_entity
    end

  end

  def destroy
    @game = Game.find(params[:id])
    valid_user
    @game.destroy
    redirect_to games_path
  end

  def forfeit
    @game = Game.find_by(params[:id])
    black_player = @game.black_user_id
    white_player = @game.white_user_id
    
    if current_user.id == white_player
      winner_id = black_player
    else
      winner_id = white_player
    end
    @game.update_attributes(winner_user_id: winner_id, loser_user_id: current_user.id, state: "end", turn: 0)
    redirect_to games_path
  end

  def index
    @open_games = Game.where(black_user_id: nil).where.not(white_user_id: current_user.id).first(15)
    @active_games = Game.where.not(white_user_id: nil).where.not(black_user_id: nil).where(winner_user_id: nil)
    @unmatched_games = Game.where(black_user_id: nil).where(white_user_id: current_user.id)
    @completed_games = Game.where(black_user_id: current_user.id).where(state: "end") || Game.where(white_user_id: current_user.id).where(state: "end") 
  end

  def update
    @game = Game.find(params[:id])
    @game.update(black_user_id: current_user.id)
    @game.reset_pieces_player
    redirect_to game_path
  end

  private

  def game_params
    params.require(:game).permit(:name, :white_user_id, :black_user_id)
  end
  
  def valid_user
    if @game.white_user_id != current_user.id || @game.black_user_id != current_user.id
      return render plain: 'Not Allowed', status: :forbidden
    end
  end
end

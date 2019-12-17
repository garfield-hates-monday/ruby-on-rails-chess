class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :index, :update, :destroy, :forfeit]

  def new
    @game = Game.new
  end

  def show
    @game = Game.find_by_id(params[:id])
    @pieces = @game.pieces.all
    return render_not_found if @game.blank?
  end

  def create
    @game = Game.create(game_params.merge(white_user_id: current_user.id))
    @game.save

    if @game.valid?
      redirect_to game_path(@game)
    else
      render :new, status: :unprocessable_entity
    end

  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy
    redirect_to games_path
  end

  def forfeit
    @game = Game.find_by_id(params[:id])
    if current_user.id == @game.white_player_user_id
      @game.update_attributes(winner_user_id: @game.black_player_user_id, loser_user_id: @game.white_player_user_id, state: "end", turn: "end")
    else
      @game.update_attributes(winner_user_id: @game.white_player_user_id, loser_user_id: @game.black_player_user_id, state: "end", turn: "end")
    end
    redirect_to games_path

  end

  def index
    @open_games = Game.where(black_user_id: nil).where.not(white_user_id: current_user.id).first(15)
    @active_games = Game.where.not(white_user_id: nil).where.not(black_user_id: nil).where(winner_user_id: nil)
    @unmatched_games = Game.where(black_user_id: nil).where(white_user_id: current_user.id)
  end

  def update
    @game = Game.find(params[:id])
    @game.update(black_user_id: current_user.id)
    redirect_to game_path
  end

  private

  def game_params
    params.require(:game).permit(:name, :white_user_id, :black_user_id)
  end
  
end

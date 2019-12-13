class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :index, :update]

  def new
    @game = Game.new
  end

  def show
    @game = Game.find_by_id(params[:id])
    @pieces = @game.pieces.all
    return render_not_found if @game.blank?
  end

  def create
    @game = Game.create(game_params.merge(white_user_id: current_user))
    @game.save

    if @game.valid?
      redirect_to game_path(@game)
    else
      render :new, status: :unprocessable_entity
    end

  end

  def index
    @open_games = Game.where(black_user_id: nil).where.not(white_user_id: current_user.id).first(15)
    @active_games = Game.where.not(white_user_id: nil).where.not(black_user_id: nil).where(winner_user_id: nil)
  end

  def update
    @game = Game.find(params[:id])
    @game.update(black_user_id: current_user)
    redirect_to game_path
  end

  private

  def game_params
    params.require(:game).permit(:name, :white_user_id, :black_user_id)
  end
  
end

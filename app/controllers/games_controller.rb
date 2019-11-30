class GamesController < ApplicationController

  def new
    @game = Game.new
  end

  def show
    @game = Game.find_by_id(params[:id])
    return render_not_found if @game.blank?
  end

  def create
    @game = Game.create(game_params)
    @game.white_user_id = current_user
    @game.save

    if @game.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end

  end

  def index
    @games = Game.all
  end

  def update
    @game = Game.find(params[:id])
    @game.update(black_user_id: current_user.id)
    redirect_to games_path
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end
  
end

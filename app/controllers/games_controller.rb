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

    if @game.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end

  end

  private

  def game_params
    params.require(:game).permit(:name, :white_user_id, :black_user_id, :turn, :state)
  end
  
end

class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @active_games = current_user.games.where(state: nil)
    @completed_games = current_user.games.where(state: 'end')
  end



end

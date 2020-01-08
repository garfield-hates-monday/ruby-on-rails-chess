class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @active_games = current_user.games.where(state: nil).where.not(black_user_id: nil)
    @completed_games = current_user.games.where(state: 'end')
    @user_wins = current_user.games.where(state: 'end').where(winner_user_id: current_user.id).count
    @user_losses = current_user.games.where(state: 'end').where(loser_user_id: current_user.id).count
    @user_draws = current_user.games.where(state: 'stalemate').count
  end
end

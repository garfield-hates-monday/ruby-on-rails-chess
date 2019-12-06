class AlterGamesAddWinnerId < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :winner_user_id, :integer
    add_column :games, :loser_user_id, :integer
  end
end

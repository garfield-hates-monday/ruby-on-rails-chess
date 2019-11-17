class AddColumnsToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :white_user_id, :integer
    add_column :games, :black_user_id, :integer
    add_column :games, :turn, :integer
    add_column :games, :state, :string
  end
end

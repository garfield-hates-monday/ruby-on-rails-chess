class RemoveTurnColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :games, :turn
  end
end

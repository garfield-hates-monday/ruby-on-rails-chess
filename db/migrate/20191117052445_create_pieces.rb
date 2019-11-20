class CreatePieces < ActiveRecord::Migration[5.2]
  def change
    create_table :pieces do |t|
      t.integer :x_position
      t.integer :y_position
      t.string :color
      t.string :type
      t.boolean :captured
      t.integer :game_id
      t.integer :user_id
      t.timestamps
    end
  end
end

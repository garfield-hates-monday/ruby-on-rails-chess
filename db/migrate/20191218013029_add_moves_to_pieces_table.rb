class AddMovesToPiecesTable < ActiveRecord::Migration[5.2]
  def change
    add_column :pieces, :moves, :integer, default: 0
  end
end

class AddSessionToHand < ActiveRecord::Migration
  def self.up
    add_column :hands, :session_id, :integer
    add_column :hands, :starting_at, :integer
    add_column :hands, :pot, :string
    add_column :hands, :board, :string
    add_index :hands, :session_id
  end

  def self.down
    remove_column :hands, :board
    remove_column :hands, :pot
    remove_column :hands, :starting_at
    remove_column :hands, :session_id
    remove_index :hands, :session_id
  end
end

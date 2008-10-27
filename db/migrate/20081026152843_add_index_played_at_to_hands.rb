class AddIndexPlayedAtToHands < ActiveRecord::Migration
  def self.up
    add_index :hands, :played_at
  end

  def self.down
    remove_index :hands, :played_at
  end
end

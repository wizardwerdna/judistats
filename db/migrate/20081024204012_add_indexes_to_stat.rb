class AddIndexesToStat < ActiveRecord::Migration
  def self.up
    add_index :stats, :player_id
    add_index :stats, :session_id
    add_index :stats, :hand_id
  end

  def self.down
    remove_index :stats, :player_id
    remove_index :stats, :session_id
    remove_index :stats, :hand_id
  end
end

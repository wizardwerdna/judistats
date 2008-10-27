class AddIndexesToPlayers < ActiveRecord::Migration
  def self.up
    add_index :players, :screen_name
  end

  def self.down
    remove_index :players, :screen_name
  end
end

class AddIndexesToHand < ActiveRecord::Migration
  def self.up
    add_index :hands, :name
  end

  def self.down
    remove_index :hands, :name
  end
end

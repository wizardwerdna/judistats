class AddRakeToHand < ActiveRecord::Migration
  def self.up
    add_column :hands, :total_pot, :decimal, :precision => 15, :scale => 2
    add_column :hands, :rake, :decimal, :precision => 15, :scale => 2
  end

  def self.down
    remove_column :hands, :total_pot
    remove_column :hands, :rake
  end
end

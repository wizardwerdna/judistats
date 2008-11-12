class AddNetToStats < ActiveRecord::Migration
  def self.up
    add_column :stats, :net, :decimal, :precision => 15, :scale => 2
    add_column :stats, :net_in_bb, :decimal, :precision => 15, :scale => 2
  end

  def self.down
    remove_column :stats, :net
    remove_column :stats, :net_in_bb
  end
end

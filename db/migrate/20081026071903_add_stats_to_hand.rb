class AddStatsToHand < ActiveRecord::Migration
  def self.up
    add_column :hands, :description, :string
    add_column :hands, :sb, :string
    add_column :hands, :bb, :string
    add_column :hands, :played_at, :timestamp
    add_column :hands, :tournament, :string
  end

  def self.down
    remove_column :hands, :tournament
    remove_column :hands, :played_at
    remove_column :hands, :bb
    remove_column :hands, :sb
    remove_column :hands, :description
  end
end

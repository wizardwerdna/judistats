class AlterHandMoney < ActiveRecord::Migration
  def self.up
    change_column :hands, :sb, :decimal, :precision => 15, :scale => 2
    change_column :hands, :bb, :decimal, :precision => 15, :scale => 2
    change_column :stats, :posted, :decimal, :precision => 15, :scale => 2
    change_column :stats, :bet, :decimal, :precision => 15, :scale => 2
    change_column :stats, :cashed, :decimal, :precision => 15, :scale => 2
  end

  def self.down
    change_column :hands, :sb, :string
    change_column :hands, :bb, :string
    change_column :stats, :posted, :string
    change_column :stats, :bet, :string
    change_column :stats, :cashed, :string
  end
end

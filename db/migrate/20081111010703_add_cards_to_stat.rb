class AddCardsToStat < ActiveRecord::Migration
  def self.up
    add_column :stats, :cards, :string
    add_column :stats, :cards_class, :string
  end

  def self.down
    remove_column :stats, :cards
    remove_column :stats, :cards_class
  end
end

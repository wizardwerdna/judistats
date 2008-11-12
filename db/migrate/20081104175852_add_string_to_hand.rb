class AddStringToHand < ActiveRecord::Migration
  def self.up
    add_column :hands, :hole_cards, :string
    add_column :hands, :hole_class, :string
    add_index :hands, :hole_class
  end

  def self.down
    remove_column :hands, :hole_class
    remove_column :hands, :hole_cards
    remove_index :hands, :hole_class
  end
end

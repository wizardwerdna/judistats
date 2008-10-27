class CreateStats < ActiveRecord::Migration
  def self.up
    create_table :stats do |t|
      t.integer :session_id
      t.integer :player_id
      t.integer :hand_id
      t.integer :seat
      t.integer :position
      t.integer :vpip
      t.integer :pfrp
      t.integer :preflop_aggressive
      t.integer :preflop_passive
      t.integer :postflop_aggressive
      t.integer :postflop_passive
      t.integer :posted
      t.integer :bet
      t.integer :cashed
      t.timestamps
    end
  end
  
  def self.down
    drop_table :stats
  end
end

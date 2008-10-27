class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :screen_name
      t.string :rating
      t.string :icon
      t.timestamp :updated
      t.timestamps
    end
  end
  
  def self.down
    drop_table :players
  end
end

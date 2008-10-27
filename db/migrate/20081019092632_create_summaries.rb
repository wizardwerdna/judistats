class CreateSummaries < ActiveRecord::Migration
  def self.up
    create_table :summaries do |t|
      t.integer :ftfile_id
      t.integer :position
      t.string :screen_name
      t.integer :hands
      t.integer :vpip
      t.integer :pfrp
      t.float :pre_agg
      t.float :post_agg
      t.string :poker_edge
      t.timestamps
    end
  end
  
  def self.down
    drop_table :summaries
  end
end

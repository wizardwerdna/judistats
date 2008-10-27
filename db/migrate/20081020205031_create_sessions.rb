class CreateSessions < ActiveRecord::Migration
  def self.up
    create_table :sessions do |t|
      t.string :prefix
      t.string :player
      t.string :file
      t.timestamp :mtime
      t.timestamp :parsed_at
      t.timestamps
    end
  end
  
  def self.down
    drop_table :sessions
  end
end

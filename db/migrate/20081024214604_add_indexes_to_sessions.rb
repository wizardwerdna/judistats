class AddIndexesToSessions < ActiveRecord::Migration
  def self.up
    add_index :sessions, :mtime
    add_index :sessions, :file
  end

  def self.down
    remove_index :sessions, :mtime
    remove_index :sessions, :file
  end
end

class CreateFtfiles < ActiveRecord::Migration
  def self.up
    create_table :ftfiles do |t|
      t.string :folder
      t.string :file
      t.timestamp :mtime

      t.timestamps
    end
  end

  def self.down
    drop_table :ftfiles
  end
end

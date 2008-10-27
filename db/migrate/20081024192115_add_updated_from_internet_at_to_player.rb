class AddUpdatedFromInternetAtToPlayer < ActiveRecord::Migration
  def self.up
    add_column :players, :updated_from_internet_at, :timestamp
    remove_column :players, :updated
  end

  def self.down
    remove_column :players, :updated_from_internet_at
    add_column :players, :updated, :timestamp
  end
end

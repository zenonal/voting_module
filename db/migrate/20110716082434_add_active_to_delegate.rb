class AddActiveToDelegate < ActiveRecord::Migration
  def self.up
    add_column :delegates, :active, :boolean, :default => true
  end

  def self.down
    remove_column :delegates, :active
  end
end

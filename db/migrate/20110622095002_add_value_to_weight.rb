class AddValueToWeight < ActiveRecord::Migration
  def self.up
    add_column :weights, :value, :integer
  end

  def self.down
    remove_column :weights, :value
  end
end

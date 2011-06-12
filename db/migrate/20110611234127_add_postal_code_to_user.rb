class AddPostalCodeToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :postal_code, :integer
  end

  def self.down
    remove_column :users, :postal_code
  end
end

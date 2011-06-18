class AddProvinceIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :province_id, :integer
    add_column :users, :commune_id, :integer
    add_column :users, :region_id, :integer
    remove_column :users, :postal_code
  end

  def self.down
    remove_column :users, :province_id
    remove_column :users, :commune_id
    remove_column :users, :region_id
    add_column :users, :postal_code, :integer
  end
end

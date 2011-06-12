class RemoveNameFromRegion < ActiveRecord::Migration
  def self.up
    add_column :regions, :code, :integer
    remove_column :regions, :name
  end

  def self.down
    remove_column :regions, :code
    add_column :regions, :name, :string
  end
end

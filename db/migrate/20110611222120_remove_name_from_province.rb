class RemoveNameFromProvince < ActiveRecord::Migration
  def self.up
    add_column :provinces, :code, :integer
    remove_column :provinces, :name
  end

  def self.down
    remove_column :provinces, :code
    add_column :provinces, :name, :string
  end
end

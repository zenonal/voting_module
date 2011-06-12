class RemoveNameFromCommune < ActiveRecord::Migration
  def self.up
    remove_column :communes, :name
  end

  def self.down
    add_column :communes, :name, :string
  end
end

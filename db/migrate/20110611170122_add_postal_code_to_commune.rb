class AddPostalCodeToCommune < ActiveRecord::Migration
  def self.up
    add_column :communes, :postal_code, :integer
  end

  def self.down
    remove_column :communes, :postal_code
  end
end

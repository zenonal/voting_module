class AddCategoryIdToReferendum < ActiveRecord::Migration
  def self.up
    add_column :referendums, :category_id, :integer
  end

  def self.down
    remove_column :referendums, :category_id
  end
end

class AddAmendmentableIdToAmendments < ActiveRecord::Migration
  def self.up
    add_column :amendments, :amendmentable_id, :integer
    add_column :amendments, :amendmentable_type, :string
  end

  def self.down
    remove_column :amendments, :amendmentable_type
    remove_column :amendments, :amendmentable_id
  end
end

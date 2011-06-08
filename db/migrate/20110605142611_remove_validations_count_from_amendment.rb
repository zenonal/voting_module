class RemoveValidationsCountFromAmendment < ActiveRecord::Migration
  def self.up
    remove_column :amendments, :validations_count
  end

  def self.down
    add_column :amendments, :validations_count, :integer
  end
end

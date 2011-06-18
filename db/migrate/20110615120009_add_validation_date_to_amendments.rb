class AddValidationDateToAmendments < ActiveRecord::Migration
  def self.up
    add_column :amendments, :validation_date, :datetime
  end

  def self.down
    remove_column :amendments, :validation_date
  end
end

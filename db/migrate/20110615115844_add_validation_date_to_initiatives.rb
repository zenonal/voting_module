class AddValidationDateToInitiatives < ActiveRecord::Migration
  def self.up
    add_column :initiatives, :validation_date, :datetime
  end

  def self.down
    remove_column :initiatives, :validation_date
  end
end

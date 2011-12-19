class AddValidationsToReferendums < ActiveRecord::Migration
  def self.up
    add_column :referendums, :validated, :boolean, :default => false
    add_column :referendums, :validation_date, :datetime
  end

  def self.down
    remove_column :referendums, :validation_date
    remove_column :referendums, :validated
  end
end

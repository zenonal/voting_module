class AddValidationsCountToAmendments < ActiveRecord::Migration
  def self.up
    add_column :amendments, :validations_count, :integer, :default => 0
    
    Amendment.reset_column_information
    Amendment.all.each do |a|
      Amendment.update_counters a.id, :validations_count => a.validations.length
    end
  end

  def self.down
    remove_column :amendments, :validations_count
  end
end

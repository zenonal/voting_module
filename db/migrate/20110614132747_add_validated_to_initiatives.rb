class AddValidatedToInitiatives < ActiveRecord::Migration
  def self.up
    add_column :initiatives, :validated, :boolean, :default => false
    add_column :amendments, :validated, :boolean, :default => false
  end

  def self.down
    remove_column :initiatives, :validated
    remove_column :amendments, :validated
  end
end

class AddPartyIdToPolitician < ActiveRecord::Migration
  def self.up
    add_column :politicians, :party_id, :integer
  end

  def self.down
    remove_column :politicians, :party_id
  end
end

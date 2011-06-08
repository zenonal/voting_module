class RemoveValidationIdFromInitiative < ActiveRecord::Migration
  def self.up
    remove_column :initiatives, :validation_id
  end

  def self.down
    add_column :initiatives, :validation_id, :integer
  end
end

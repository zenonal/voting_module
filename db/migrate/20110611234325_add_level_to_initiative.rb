class AddLevelToInitiative < ActiveRecord::Migration
  def self.up
    add_column :initiatives, :level, :string
  end

  def self.down
    remove_column :initiatives, :level
  end
end

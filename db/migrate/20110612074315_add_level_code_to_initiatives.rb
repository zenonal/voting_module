class AddLevelCodeToInitiatives < ActiveRecord::Migration
  def self.up
    add_column :initiatives, :level_code, :integer
  end

  def self.down
    remove_column :initiatives, :level_code
  end
end

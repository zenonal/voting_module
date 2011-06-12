class AddLevelToReferendum < ActiveRecord::Migration
  def self.up
    add_column :referendums, :level, :string
  end

  def self.down
    remove_column :referendums, :level
  end
end

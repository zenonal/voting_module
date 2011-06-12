class AddLevelCodeToReferendums < ActiveRecord::Migration
  def self.up
    add_column :referendums, :level_code, :integer
  end

  def self.down
    remove_column :referendums, :level_code
  end
end

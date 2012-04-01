class AddCommunityIdToBills < ActiveRecord::Migration
  def self.up
    add_column :initiatives, :community_id, :integer
    add_column :referendums, :community_id, :integer
  end

  def self.down
    remove_column :initiatives, :community_id
    remove_column :referendums, :community_id
  end
end

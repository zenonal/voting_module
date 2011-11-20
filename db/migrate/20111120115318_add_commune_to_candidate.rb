class AddCommuneToCandidate < ActiveRecord::Migration
  def self.up
    add_column :candidates, :commune_id, :integer
    add_column :candidates, :province_id, :integer
    add_column :candidates, :region_id, :integer
  end

  def self.down
    remove_column :candidates, :region_id
    remove_column :candidates, :province_id
    remove_column :candidates, :commune_id
  end
end

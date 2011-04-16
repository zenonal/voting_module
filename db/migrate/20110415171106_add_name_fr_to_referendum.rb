class AddNameFrToReferendum < ActiveRecord::Migration
  def self.up
    add_column :referendums, :name_fr, :string
    add_column :referendums, :name_nl, :string
  end

  def self.down
    remove_column :referendums, :name_fr
    remove_column :referendums, :name_nl
  end
end

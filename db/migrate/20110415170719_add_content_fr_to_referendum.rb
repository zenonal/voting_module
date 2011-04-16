class AddContentFrToReferendum < ActiveRecord::Migration
  def self.up
    add_column :referendums, :content_fr, :text
    add_column :referendums, :content_nl, :text
  end

  def self.down
    remove_column :referendums, :content_fr
    remove_column :referendums, :content_nl
  end
end

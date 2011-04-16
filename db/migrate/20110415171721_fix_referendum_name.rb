class FixReferendumName < ActiveRecord::Migration
  def self.up
    rename_column :referendums, :name, :name_en
    rename_column :referendums, :content, :content_en
  end

  def self.down
    rename_column :referendums, :name_en, :name
    rename_column :referendums, :content_en, :content
  end
end

class AddContentFrToBios < ActiveRecord::Migration
  def self.up
    remove_column :bios, :content
    add_column :bios, :content_fr, :text
    add_column :bios, :content_nl, :text
    add_column :bios, :content_en, :text
  end

  def self.down
    add_column :bios, :content, :text
    remove_column :bios, :content_nl
    remove_column :bios, :content_fr
    remove_column :bios, :content_en
  end
end

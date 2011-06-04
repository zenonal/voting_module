class AddWikiFrToBios < ActiveRecord::Migration
  def self.up
    remove_column :bios, :wiki
    add_column :bios, :wiki_fr, :string
    add_column :bios, :wiki_nl, :string
    add_column :bios, :wiki_en, :string
  end

  def self.down
    add_column :bios, :wiki, :string
    remove_column :bios, :wiki_nl
    remove_column :bios, :wiki_fr
    remove_column :bios, :wiki_en
  end
end

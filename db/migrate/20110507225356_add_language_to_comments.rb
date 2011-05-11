class AddLanguageToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :language, :string
  end

  def self.down
    remove_column :comments, :language
  end
end

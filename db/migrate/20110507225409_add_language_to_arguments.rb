class AddLanguageToArguments < ActiveRecord::Migration
  def self.up
    add_column :arguments, :language, :string
  end

  def self.down
    remove_column :arguments, :language
  end
end

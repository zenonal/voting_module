class AddTitleToArguments < ActiveRecord::Migration
  def self.up
    add_column :arguments, :title, :string
  end

  def self.down
    remove_column :arguments, :title
  end
end

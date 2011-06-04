class AddPhotoFileNameToParty < ActiveRecord::Migration
  def self.up
    add_column :parties, :photo_file_name, :string
    add_column :parties, :photo_content_type, :string
    add_column :parties, :photo_file_size, :integer
    add_column :parties, :photo_updated_at, :datetime
  end

  def self.down
    remove_column :parties, :photo_file_name
    remove_column :parties, :photo_content_type
    remove_column :parties, :photo_file_size
    remove_column :parties, :photo_updated_at
  end
end

class CreateCommunities < ActiveRecord::Migration
  def self.up
    create_table :communities do |t|
      t.string :name
      t.string :uploadedPhoto_file_name
      t.string :uploadedPhoto_content_type
      t.integer :uploadedPhoto_file_size
      t.datetime :uploadedPhoto_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :communities
  end
end

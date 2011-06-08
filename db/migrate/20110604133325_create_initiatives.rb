class CreateInitiatives < ActiveRecord::Migration
  def self.up
    create_table :initiatives do |t|
      t.string :name_en
      t.text :content_en
      t.string :name_fr
      t.text :content_fr
      t.string :name_nl
      t.text :content_nl
      t.integer :category_id
      t.integer :user_id
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
      t.integer :validation_id

      t.timestamps
    end
  end

  def self.down
    drop_table :initiatives
  end
end

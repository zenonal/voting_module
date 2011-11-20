class CreateCandidates < ActiveRecord::Migration
  def self.up
    create_table :candidates do |t|
      t.string :name
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
      t.string :level
      t.integer :level_code

      t.timestamps
    end
  end

  def self.down
    drop_table :candidates
  end
end

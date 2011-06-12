class CreateIdeas < ActiveRecord::Migration
  def self.up
    create_table :ideas do |t|
      t.integer :brainstorm_id
      t.integer :user_id
      t.text :content_en
      t.text :content_fr
      t.text :content_nl

      t.timestamps
    end
  end

  def self.down
    drop_table :ideas
  end
end

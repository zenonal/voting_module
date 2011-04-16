class CreateArguments < ActiveRecord::Migration
  def self.up
    create_table :arguments do |t|
      t.text :content
      t.integer :user_id
      t.boolean :pro
      t.integer :argumentable_id
      t.string :argumentable_type

      t.timestamps
    end
  end

  def self.down
    drop_table :arguments
  end
end

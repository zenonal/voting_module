class CreateBrainstorms < ActiveRecord::Migration
  def self.up
    create_table :brainstorms do |t|
      t.string :brainstormable_type
      t.integer :brainstormable_id

      t.timestamps
    end
  end

  def self.down
    drop_table :brainstorms
  end
end

class CreateBios < ActiveRecord::Migration
  def self.up
    create_table :bios do |t|
      t.text :content
      t.string :wiki
      t.string :bioable_type
      t.integer :bioable_id

      t.timestamps
    end
  end

  def self.down
    drop_table :bios
  end
end

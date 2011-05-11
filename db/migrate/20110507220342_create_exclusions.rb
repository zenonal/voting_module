class CreateExclusions < ActiveRecord::Migration
  def self.up
    create_table :exclusions do |t|
      t.integer :user_id
      t.integer :excludable_id
      t.string :excludable_type

      t.timestamps
    end
  end

  def self.down
    drop_table :exclusions
  end
end

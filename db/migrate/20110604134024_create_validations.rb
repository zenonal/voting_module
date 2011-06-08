class CreateValidations < ActiveRecord::Migration
  def self.up
    create_table :validations do |t|
      t.integer :initiative_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :validations
  end
end

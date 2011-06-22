class CreateWeights < ActiveRecord::Migration
  def self.up
    create_table :weights do |t|
      t.integer :delegate_id
      t.integer :weightable_id
      t.string :weightable_type

      t.timestamps
    end
  end

  def self.down
    drop_table :weights
  end
end

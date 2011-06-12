class CreateCommunes < ActiveRecord::Migration
  def self.up
    create_table :communes do |t|
      t.string :name
      t.integer :province_id

      t.timestamps
    end
  end

  def self.down
    drop_table :communes
  end
end

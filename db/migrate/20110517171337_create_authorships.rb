class CreateAuthorships < ActiveRecord::Migration
  def self.up
    create_table :authorships do |t|
      t.integer :politician_id
      t.integer :referendum_id

      t.timestamps
    end
  end

  def self.down
    drop_table :authorships
  end
end

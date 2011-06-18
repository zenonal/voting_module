class CreateRankings < ActiveRecord::Migration
  def self.up
    create_table :rankings do |t|
      t.string :rankable_type
      t.integer :rankable_id
      t.integer :rank
      t.string :ranker_type
      t.integer :ranker_id

      t.timestamps
    end
  end

  def self.down
    drop_table :rankings
  end
end

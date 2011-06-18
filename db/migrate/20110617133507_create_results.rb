class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.integer :condorcet_winner
      t.string :resultable_type
      t.integer :resultable_id

      t.timestamps
    end
  end

  def self.down
    drop_table :results
  end
end

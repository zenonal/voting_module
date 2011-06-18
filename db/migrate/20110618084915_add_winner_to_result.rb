class AddWinnerToResult < ActiveRecord::Migration
  def self.up
    add_column :results, :winner, :boolean
  end

  def self.down
    remove_column :results, :winner
  end
end

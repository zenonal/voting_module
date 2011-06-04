class CreateDelegations < ActiveRecord::Migration
  def self.up
    create_table :delegations do |t|
      t.integer :user_id
      t.integer :delegate_id

      t.timestamps
    end
  end

  def self.down
    drop_table :delegations
  end
end

class AddValidableTypeToValidations < ActiveRecord::Migration
  def self.up
    add_column :validations, :validable_type, :string
    add_column :validations, :validable_id, :integer
    remove_column :validations, :initiative_id
  end

  def self.down
    remove_column :validations, :validable_id
    remove_column :validations, :validable_type
    add_column :validations, :initiative_id, :integer
  end
end

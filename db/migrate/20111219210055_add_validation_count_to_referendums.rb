class AddValidationCountToReferendums < ActiveRecord::Migration
  def self.up
    add_column :referendums, :validations_count, :integer, :default => 0
    
    
    Referendum.reset_column_information  
    Referendum.all.each do |p|  
      p.update_attribute :validations_count, p.validations.length  
    end
    
  end

  def self.down
    remove_column :referendums, :validations_count
  end
end

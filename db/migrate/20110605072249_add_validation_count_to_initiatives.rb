class AddValidationCountToInitiatives < ActiveRecord::Migration
  def self.up
    add_column :initiatives, :validations_count, :integer, :default => 0 
    
    Initiative.reset_column_information  
    Initiative.all.each do |p|  
      p.update_attribute :validations_count, p.validations.length  
    end
        
  end

  def self.down
    remove_column :initiatives, :validations_count
  end
end

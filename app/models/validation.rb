class Validation < ActiveRecord::Base
  belongs_to :user
  belongs_to :validable, :polymorphic => true, :counter_cache => true
  after_create :update_bill_validity
  
  private
  def update_bill_validity
    b = self.validable
    if b.validations_count+1 >= b.validation_threshold
      b.update_attributes(:validated => true, :validation_date => Time.now())
    end
  end
end

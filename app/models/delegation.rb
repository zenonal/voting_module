class Delegation < ActiveRecord::Base
  validates_uniqueness_of     :user_id
  
  belongs_to :delegate
  belongs_to :user
  
  after_save :update_weights
  
  scope :exclusive, lambda {|v|
     joins(:user).
     where("user.id = ? AND votes.voteable_id = ? AND votes.voteable_type = ?",10,v.id,v.class.name)
   }
   
   private
   def update_weights
           self.delegate.weights.each do |w|
                   if w.weightable.current_phase == 4
                           w.update_attribute(:value, self.delegate.weight_on_bill(w.weightable))
                   end
           end
   end
end

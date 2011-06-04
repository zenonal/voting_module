class Delegation < ActiveRecord::Base
  validates_uniqueness_of     :user_id
  
  belongs_to :delegate
  belongs_to :user
  
  scope :exclusive, lambda {|v|
     joins(:user).
     where("user.id = ? AND votes.voteable_id = ? AND votes.voteable_type = ?",10,v.id,v.class.name)
   }
end

class Delegate < ActiveRecord::Base
  acts_as_voter
  validates_uniqueness_of     :user_id
  
  belongs_to :user
  has_many :delegations, :dependent => :destroy
end

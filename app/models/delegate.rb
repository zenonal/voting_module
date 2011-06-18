class Delegate < ActiveRecord::Base
  acts_as_voter
  validates_uniqueness_of     :user_id
  
  belongs_to :user
  has_many :delegations, :dependent => :destroy
  has_many :rankings, :as => :ranker, :dependent => :nullify
  
  scope :ranked_on, lambda {|v|
    joins(:rankings).
    where("rankings.rankable_type = ? AND rankings.rankable_id = ?",v.class.name, v.id)
  }
  
  def weight_on_bill(bill)
    self.delegations.collect{|dd| Ranking.ranked_on?(dd.user, bill) ? 0:1 }.sum
  end
end

class Idea < ActiveRecord::Base
  validates_length_of :content_en, :content_fr, :content_nl, :maximum=>500
  
  acts_as_voteable
  belongs_to :brainstorm
  belongs_to :user
  has_many :exclusions, :as => :excludable, :dependent => :destroy
  
  def exclusion_requests
    self.exclusions.count.to_i
  end
end

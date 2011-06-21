class Idea < ActiveRecord::Base
  validates_length_of :content_en, :content_fr, :content_nl, :maximum=>500
  
  acts_as_voteable
  belongs_to :brainstorm
  belongs_to :user
  has_many :exclusions, :as => :excludable, :dependent => :destroy
  
  scope :for_bill, lambda {|b|
      joins(:brainstorm).
      where("brainstormable_type = ? AND brainstormable_id = ?", b.class.name, b.id)
  }
  
  scope :from_user, lambda {|u|
        where("user_id = ?", u.id)
    }
  
  scope :not_from_user, lambda {|u|
        where("user_id != ?", u.id)
    }
  
  def exclusion_requests
    self.exclusions.count.to_i
  end
end

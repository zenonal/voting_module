class Argument < ActiveRecord::Base
  acts_as_voteable
  validates_presence_of     :content
  validates_length_of       :content, :within => 2..400
  
  belongs_to :argumentable, :polymorphic => true
  belongs_to :users
  has_many :exclusions, :as => :excludable, :dependent => :destroy
  
  def is_pro?
     self.pro == true
  end
  def is_con?
     self.pro == false
  end
  def self.all_pros
    find(:all, :conditions => {:pro => true, :language => I18n.locale})
  end
  def self.all_cons
    find(:all, :conditions => {:pro => false, :language => I18n.locale})
  end
  def score
    if votes_count>0
    votes_for.to_f/votes_count.to_f
    else
      0
    end
  end
  def exclusion_requests
    self.exclusions.count.to_i
  end
end

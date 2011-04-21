class Argument < ActiveRecord::Base
  acts_as_voteable
  validates_presence_of     :content
  validates_length_of       :content, :within => 2..400
  
  belongs_to :argumentable, :polymorphic => true
  
  def is_pro?
     self.pro == true
  end
  def is_con?
     self.pro == false
  end
  def self.all_pros
    find(:all, :conditions => {:pro => true})
  end
  def self.all_cons
    find(:all, :conditions => {:pro => false})
  end
end
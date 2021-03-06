class Argument < ActiveRecord::Base
  acts_as_voteable
  validates_uniqueness_of   :content
  validates_presence_of     :content
  validates_length_of       :content, :within => 5..1500
  
  belongs_to :argumentable, :polymorphic => true
  belongs_to :user
  has_many :exclusions, :as => :excludable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  attr_accessible :content, :title
  
  scope :not_excluded, 
     :joins => 'LEFT JOIN "exclusions" ON exclusions.excludable_id = arguments.id AND exclusions.excludable_type == "Argument"' ,
     :group => Argument.column_names.collect{|column_name| "arguments.#{column_name}"}.join(","), 
     :having => "COUNT(exclusions.id) < 3"
  
  def is_pro?
     self.pro == true
  end
  def is_con?
     self.pro == false
  end
  def self.all_pros
    where(:pro => true, :language => I18n.locale)
  end
  def self.all_cons
    where(:pro => false, :language => I18n.locale)
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

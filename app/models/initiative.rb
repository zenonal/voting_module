class Initiative < ActiveRecord::Base
  validates_length_of :content_en, :content_fr, :content_nl, :maximum=>3000
  acts_as_voteable
  if Rails.env=="development"
    has_attached_file :photo, :styles => {:small => "150x150>", :thumbnail => "80x80>"}
  else
    has_attached_file :photo, 
      :storage => :s3,
      :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
      :path => ":attachment/:id/:style.:extension",
      :url => ':s3_domain_url',
      :s3_permissions => 'authenticated-read',
      :s3_protocol => 'http',
      :styles => {:small => "150x150>", :thumbnail => "80x80>"}
  end
  
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :arguments, :as => :argumentable, :dependent => :destroy
  has_many :validations, :as => :validable, :dependent => :destroy
  has_many :amendments, :as => :amendmentable, :dependent => :destroy
  has_many :brainstorms, :as => :brainstormable, :dependent => :destroy
  belongs_to :user
  belongs_to :category
  
  LEVELS = ["", "communal", "provincial", "regional", "federal"]
  
  scope :user_geographical_level, lambda { |user, level|
      where(["level = ? & level_code = ?", level, user.postal_code])
  }
  
  scope :validated, where(["validations_count >= 1"])
  
  scope :not_validated, where(["validations_count < 1"])
  
  scope :not_blank, where(["content_#{I18n.locale} != \"\""])
  
  attr_readonly :validations_count
  
  def commune
    Commune.find_by_postal_code(self.level_code)
  end
  
  def province
    Province.find_by_code(self.level_code)
  end
  
  def region
    Region.find_by_code(self.level_code)
  end
  
  def validated?
    self.validations_count >= VALIDATION_THRESHOLD
  end
end

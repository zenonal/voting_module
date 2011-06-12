class Referendum < ActiveRecord::Base
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
  has_many :authorships
  has_many :politicians, :through => :authorships
  has_many :amendments, :as => :amendmentable, :dependent => :destroy
  belongs_to :category
  
  scope :user_geographical_level, lambda { |user, level|
      where(["level = ? & level_code = ?", level, user.postal_code])
  }
  
  def commune
    Commune.find_by_postal_code(self.user.postal_code).name
  end
  
  def province
    Commune.find_by_postal_code(self.user.postal_code).province.name
  end
  
  def region
    Commune.find_by_postal_code(self.user.postal_code).province.region.name
  end
  
  def validated?
    true
  end
end

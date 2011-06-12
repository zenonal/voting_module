class Amendment < ActiveRecord::Base
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
  has_one :brainstorm, :as => :brainstormable, :dependent => :destroy
  belongs_to :user
  belongs_to :amendmentable, :polymorphic => true
  
  scope :validated, where(["validations_count >= 1"])
  
  scope :not_validated, where(["validations_count < 1"])
  
  scope :not_blank, where(["content_#{I18n.locale} != \"\""])
  
  attr_readonly :validations_count
  
  def validated?
    self.validations_count >= VALIDATION_THRESHOLD
  end
end

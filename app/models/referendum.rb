class Referendum < ActiveRecord::Base
  acts_as_voteable
  if Rails.env=="development"
    has_attached_file :photo, :styles => {:small => "150x150>", :thumbnail => "80x80>"}
  else
    has_attached_file :photo, 
      :storage => :s3,
      :bucket => 'voting-module',
      :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
      :path => ":attachment/:id/:style.:extension",
      :styles => {:small => "150x150>", :thumbnail => "80x80>"}
  end
  
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :arguments, :as => :argumentable, :dependent => :destroy
  has_many :authorships
  has_many :politicians, :through => :authorships
  has_many :amendments, :as => :amendmentable, :dependent => :destroy
  belongs_to :category
  
  def validated?
    true
  end
end

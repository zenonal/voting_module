class Party < ActiveRecord::Base
  if Rails.env=="development"
    has_attached_file :photo, :styles => {:small => "150x150>", :thumbnail => "80x80>"}
  else
    has_attached_file :photo, 
      :storage => :s3,
      :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
      :path => ":class/:attachment/:id/:style.:extension",
      :url => ':s3_domain_url',
      :s3_permissions => 'public-read',
      :s3_protocol => 'http',
      :styles => {:small => "150x150>", :thumbnail => "80x80>"}
  end
  has_many :politicians
  has_many :users
  has_many :bios, :as => :bioable, :dependent => :destroy
end

class Party < ActiveRecord::Base
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
  has_many :politicians
  has_many :users
  has_many :bios, :as => :bioable, :dependent => :destroy
end

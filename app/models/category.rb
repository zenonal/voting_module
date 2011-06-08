class Category < ActiveRecord::Base
  if Rails.env=="development"
    has_attached_file :photo, :styles => {:small => "100x100>", :thumbnail => "40x40>"}
  else
    has_attached_file :photo, 
      :storage => :s3,
      :bucket => 'voting-module',
      :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
      :path => ":attachment/:id/:style.:extension",
      :styles => {:small => "100x100>", :thumbnail => "40x40>"}
  end
  has_many :referendums
  has_many :initiatives
end

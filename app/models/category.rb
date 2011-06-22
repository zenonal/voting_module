class Category < ActiveRecord::Base
  if Rails.env=="development"
    has_attached_file :photo, :styles => {:small => "100x100>", :thumbnail => "40x40>"}
  else
    has_attached_file :photo, 
      :storage => :s3,
      :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
      :path => ":attachment/:id/:style.:extension",
      :url => ':s3_domain_url',
      :s3_permissions => 'public-read',
      :s3_protocol => 'http',
      :styles => {:small => "100x100>", :thumbnail => "40x40>"}
  end
  has_many :referendums
  has_many :initiatives
end

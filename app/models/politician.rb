class Politician < ActiveRecord::Base
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
  has_many :authorships
  has_many :referendums, :through => :authorships
  has_many :bios, :as => :bioable, :dependent => :destroy
  belongs_to :party
end

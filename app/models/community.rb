class Community < ActiveRecord::Base
        if Rails.env=="development"
                has_attached_file :uploadedPhoto, :styles => {:small => "150x150>", :thumbnail => "80x80>"}
        else
                has_attached_file :uploadedPhoto, 
                :storage => :s3,
                :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                :path => ":class/:attachment/:id/:style.:extension",
                :url => ':s3_domain_url',
                :s3_permissions => 'public-read',
                :s3_protocol => 'http',
                :styles => {:small => "150x150>", :thumbnail => "80x80>"}
        end
        has_many :referendums
        has_many :initiatives
end

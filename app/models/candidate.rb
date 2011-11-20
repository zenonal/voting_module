class Candidate < ActiveRecord::Base

belongs_to :commune
belongs_to :province
belongs_to :region

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
        has_many :bios, :as => :bioable, :dependent => :destroy
        attr_accessible :name, :photo, :level, :level_code

        def commune
                Commune.find_by_postal_code(self.level_code)
        end

        def province
                Province.find_by_code(self.level_code)
        end

        def region
                Region.find_by_code(self.level_code)
        end
end

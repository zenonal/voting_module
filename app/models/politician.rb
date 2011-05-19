class Politician < ActiveRecord::Base
  has_attached_file :photo, :styles => {:small => "150x150>", :thumbnail => "80x80>"}
  has_many :authorships
  has_many :referendums, :through => :authorships
end

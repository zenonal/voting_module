class Category < ActiveRecord::Base
  has_attached_file :photo, :styles => {:small => "100x100>", :thumbnail => "40x40>"}
  has_many :referendums
  has_many :initiatives
end

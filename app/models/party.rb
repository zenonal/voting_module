class Party < ActiveRecord::Base
  has_attached_file :photo, :styles => {:small => "150x150>", :thumbnail => "80x80>"}
  has_many :politicians
  has_many :users
  has_many :bios, :as => :bioable, :dependent => :destroy
end

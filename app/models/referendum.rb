class Referendum < ActiveRecord::Base
  acts_as_voteable
  has_attached_file :photo, :styles => {:small => "150x150>", :thumbnail => "80x80>"}
  
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :arguments, :as => :argumentable, :dependent => :destroy
  has_many :authorships
  has_many :politicians, :through => :authorships
end

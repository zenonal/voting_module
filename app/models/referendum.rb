class Referendum < ActiveRecord::Base
  acts_as_voteable
  validates_presence_of :name, :content
  validates_length_of       :content, :within => 4..1000
  has_attached_file :photo, :styles => {:small => "150x150>", :thumbnail => "80x80>"}
  
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :arguments, :as => :argumentable, :dependent => :destroy
end

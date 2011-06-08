class Amendment < ActiveRecord::Base
  validates_presence_of     :content_en, :content_fr, :content_nl, :name_en, :name_fr, :name_nl
  validates_length_of       :content_en, :content_fr, :content_nl, :within => 50..3000
  validates_uniqueness_of   :name_en, :name_fr, :name_nl
  
  acts_as_voteable
  has_attached_file :photo, :styles => {:small => "150x150>", :thumbnail => "80x80>"}
  
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :arguments, :as => :argumentable, :dependent => :destroy
  has_many :validations, :as => :validable, :dependent => :destroy
  belongs_to :user
  belongs_to :amendmentable, :polymorphic => true
  
  scope :validated, where(["validations_count >= 1"])
  
  scope :not_validated, where(["validations_count < 1"])
  
  attr_readonly :validations_count
  
  def validated?
    self.validations_count >= 1
  end
end

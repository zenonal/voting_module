class Region < ActiveRecord::Base
  has_many :provinces
  has_many :users
  has_many :candidates
  
  def name
    I18n.translate "R#{self.code}"
  end
end

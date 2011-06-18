class Region < ActiveRecord::Base
  has_many :provinces
  has_many :users
  
  def name
    I18n.translate "R#{self.code}"
  end
end

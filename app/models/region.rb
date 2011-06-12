class Region < ActiveRecord::Base
  has_many :provinces
  
  def name
    I18n.translate "R#{self.code}"
  end
end

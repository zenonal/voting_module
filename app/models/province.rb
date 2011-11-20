class Province < ActiveRecord::Base
  belongs_to :region
  has_many :communes
  has_many :users
  has_many :candidates
  
  def name
    I18n.translate "P#{self.code}"
  end
end

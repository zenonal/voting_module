class Province < ActiveRecord::Base
  belongs_to :region
  has_many :communes
  
  def name
    I18n.translate "P#{self.code}"
  end
end

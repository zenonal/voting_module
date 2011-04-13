class Referendum < ActiveRecord::Base
  validates_presence_of :name, :content
end

class Authorship < ActiveRecord::Base
  belongs_to :politician
  belongs_to :referendum
end

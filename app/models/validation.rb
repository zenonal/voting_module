class Validation < ActiveRecord::Base
  belongs_to :user
  belongs_to :validable, :polymorphic => true, :counter_cache => true
end

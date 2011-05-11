class Exclusion < ActiveRecord::Base
  belongs_to :excludable, :polymorphic => true
  belongs_to :users
end

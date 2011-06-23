class Exclusion < ActiveRecord::Base
  belongs_to :excludable, :polymorphic => true
  belongs_to :user
end

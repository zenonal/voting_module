class Result < ActiveRecord::Base
  belongs_to :resultable, :polymorphic => true
end

class Bio < ActiveRecord::Base
  belongs_to :bioable, :polymorphic => true
end

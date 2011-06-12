class Brainstorm < ActiveRecord::Base
  belongs_to :brainstormable, :polymorphic => true
  has_many :ideas, :dependent => :destroy
end

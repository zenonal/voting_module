class Weight < ActiveRecord::Base
        belongs_to :delegate
        belongs_to :weightable, :polymorphic => true
        
        scope :for_bill, lambda { |*args| {:conditions => ["weightable_id = ? AND weightable_type = ?", args.first.id, args.first.class.name]} }
end

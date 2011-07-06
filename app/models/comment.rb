class Comment < ActiveRecord::Base
  validates_presence_of     :content
  validates_length_of       :content, :within => 4..1000
  
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :exclusions, :as => :excludable, :dependent => :destroy
  scope :current_lg, lambda {|l|
    where(:language => l)
  }
  
  scope :not_excluded, 
       :joins => "LEFT JOIN `exclusions` ON exclusions.excludable_id = comments.id AND exclusions.excludable_type == 'Comment'" ,
       :group => Comment.column_names.collect{|column_name| "comments.#{column_name}"}.join(","), 
       :having => "COUNT(exclusions.id) < 3"
  
  def reply_level
    current_com = self
    level = 0
    while current_com.commentable_type == "Comment"
      level += 1
      current_com = Comment.find(current_com.commentable_id)
    end
    return level
  end
  
  def origin
    current_com = self
    level = 0
    while current_com.commentable_type == "Comment"
      level += 1
      current_com = Comment.find(current_com.commentable_id)
    end
    return current_com
  end
  
  def replies
    Comment.current_lg(I18n.locale).find(:all, :conditions => {:commentable_type => "Comment", :commentable_id => self.id})
  end
  def exclusion_requests
    self.exclusions.count.to_i
  end
end

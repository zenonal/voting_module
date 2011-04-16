class Comment < ActiveRecord::Base
  validates_presence_of     :content
  validates_length_of       :content, :within => 4..1000
  
  belongs_to :commentable, :polymorphic => true
  has_many :comments, :as => :commentable, :dependent => :destroy
  
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
    Comment.find(:all, :conditions => {:commentable_type => "Comment", :commentable_id => self.id})
  end
end

class User < ActiveRecord::Base
  acts_as_voter
  has_many :assignments
  has_many :roles, :through => :assignments
  validates_presence_of     :displayName
  before_create :define_role
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :rpx_connectable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation
  
    
  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end
  
   private
    def define_role
     self.roles << Role.find_or_create_by_name("registered_user")
     redirect_to edit_path(self)
    end
end

class User < ActiveRecord::Base
  has_many :assignments
  has_many :roles, :through => :assignments
  
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
end

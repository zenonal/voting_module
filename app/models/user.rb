class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  
  acts_as_voter
  has_many :authentications, :dependent => :destroy
  has_many :assignments
  has_many :roles, :through => :assignments
  has_many :comments, :dependent => :destroy
  before_create :define_role
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :displayName, :photo, :remember_me
  
  def apply_omniauth(omniauth)
    self.displayName = omniauth['user_info']['nickname'] if displayName.blank?
    self.photo = omniauth['user_info']['image'] if photo.blank?
    self.email = omniauth['user_info']['email'] if email.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end
    
  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end
  
  def first_login?
    self.sign_in_count==1
  end
  
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
  
   private
    def define_role
     self.roles << Role.find_or_create_by_name("registered_user")
    end
end

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  
  acts_as_voter
  has_many :authentications
  has_many :assignments
  has_many :roles, :through => :assignments
  has_many :comments, :dependent => :destroy
  before_create :define_role
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :database_authenticatable, :registerable, :oauthable,
         :recoverable, :rememberable, :trackable, :validatable, :rpx_connectable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :displayName, :photo, :remember_me
  
    
  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end
  
  def first_login?
    self.sign_in_count==1
  end
  
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
      # Get the user email info from Facebook for sign up
      # You'll have to figure this part out from the json you get back
      data = ActiveSupport::JSON.decode(access_token)

      if user = User.find_by_email(data["email"])
        user
      else
        # Create an user with a stub password.
        User.create!(:name => data["name"], :email => data["email"], :password => Devise.friendly_token)
      end
    end
  
   private
    def define_role
     self.roles << Role.find_or_create_by_name("registered_user")
    end
end

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  
  acts_as_voter
  has_many :authentications, :dependent => :destroy
  has_many :assignments
  has_many :roles, :through => :assignments, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :arguments, :dependent => :destroy
  has_many :exclusions, :dependent => :destroy
  has_many :rankings, :as => :ranker, :dependent => :nullify
  has_many :initiatives
  has_many :amendments
  has_many :ideas
  has_many :validations
  has_one :delegate
  has_one :delegation, :dependent => :destroy
  belongs_to :commune
  belongs_to :province
  belongs_to :region
  belongs_to :party
  before_create :define_role
  after_create :default_photo
  
  if Rails.env=="development"
    has_attached_file :uploadedPhoto, :styles => {:large => "128x128>", :small => "96x96>", :thumbnail => "64x64>", :verysmall => "48x48>"}
  else
    has_attached_file :uploadedPhoto, 
      :storage => :s3,
      :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
      :path => ":attachment/:id/:style.:extension",
      :url => ':s3_domain_url',
      :s3_permissions => 'public-read',
      :s3_protocol => 'http',
      :styles => {:large => "128x128>", :small => "96x96>", :thumbnail => "64x64>", :verysmall => "48x48>"}
  end
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :registerable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :displayName, :photo, :remember_me, :commune_id, :province_id, :region_id, :password, :password_confirmation, :uploadedPhoto
  
  scope :ranked_on, lambda {|v|
    joins(:rankings).
    where("rankings.rankable_type = ? AND rankings.rankable_id = ?",v.class.name, v.id)
  }
  scope :in_favor, lambda {|v|
    joins(:votes).
    where("votes.vote = ? AND votes.voteable_id = ? AND votes.voteable_type = ?",true,v.id,v.class.name)
  }
  scope :opposed_to, lambda {|v|
    joins(:votes).
    where("votes.vote = ? AND votes.voteable_id = ? AND votes.voteable_type = ?",false,v.id,v.class.name)
  }
  scope :from_commune, lambda {|c|
    joins(:commune).
    where("postal_code = ?",c.postal_code)
  }
  scope :from_province, lambda {|c|
    joins(:province).
    where("code = ?",c.code)
  }
  scope :from_region, lambda {|c|
    joins(:region).
    where("code = ?",c.code)
  }
  scope :logged_in_since, lambda {|t|
    where("last_sign_in_at > ?", t)
  }
  
  scope :logged_in_between, lambda {|t1,t2|
    where("last_sign_in_at > ? AND last_sign_in_at < ?", t1,t2)
  }

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

  def has_no_password?
    self.encrypted_password.blank?
  end
  
   private
    def define_role
     self.roles << Role.find_or_create_by_name("registered_user")
    end
    
    def default_photo
        if self.photo.nil? 
           self.update_attribute(:photo, "/public/images/unknownuser.jpg")
        end
    end
    
end

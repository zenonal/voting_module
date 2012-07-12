class Initiative < ActiveRecord::Base
  validates_length_of :content_en, :content_fr, :content_nl, :maximum=>50000
  acts_as_voteable
  if Rails.env=="development"
    has_attached_file :photo, :styles => {:small => "150x150>", :thumbnail => "80x80>"}
  else
    has_attached_file :photo, 
      :storage => :s3,
      :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
      :path => ":class/:attachment/:id/:style.:extension",
      :url => ':s3_domain_url',
      :s3_permissions => 'public-read',
      :s3_protocol => 'http',
      :styles => {:small => "150x150>", :thumbnail => "80x80>"},
      :default_url => "/images/default_bill_image/:style/missing.png"
  end
  
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :arguments, :as => :argumentable, :dependent => :destroy
  has_many :validations, :as => :validable, :dependent => :destroy
  has_many :amendments, :as => :amendmentable, :dependent => :destroy
  has_many :rankings, :as => :rankable, :dependent => :destroy
  has_many :weights, :as => :weightable, :dependent => :destroy
  has_one :brainstorm, :as => :brainstormable, :dependent => :destroy
  has_one :result, :as => :resultable, :dependent => :destroy
  belongs_to :user
  belongs_to :category
  belongs_to :community
  
  attr_accessible :name_en, :name_fr, :name_nl, :content_en, :content_fr, :content_nl, :photo, :level, :level_code
  
  LEVELS = ["", I18n.t("initiatives.level1"), I18n.t("initiatives.level2"), I18n.t("initiatives.level3"), I18n.t("initiatives.level4")]
  PHASES = ["", I18n.t("initiatives.phase0"), I18n.t("initiatives.phase1"),I18n.t("initiatives.phase2"),I18n.t("initiatives.phase3"),I18n.t("initiatives.phase4"),I18n.t("initiatives.phase5")]
  
  
  #tanker
  #include Tanker
  if Rails.env=="development"
          indexName = 'development_initiative_index'
  else
          indexName = 'production_initiative_index'
  end
  tankit indexName do
      indexes :name_en
      indexes :name_fr
      indexes :name_nl
      indexes :content_en
      indexes :content_fr
      indexes :content_nl
      indexes :id
      indexes :author_names do
            user.nil? ? nil : user.displayName
      end
      
      functions do
            {
              1 => 'relevance / age'
            }
      end
      
    end
    after_save :update_tank_indexes
    after_destroy :delete_tank_indexes
        
    
  def validation_threshold
    t = MIN_VALIDATION_THRESHOLD
    start = self.created_at
    i = self
    level = i.level
    code = i.level_code
    if level.nil?
      t = (3*(User.logged_in_between(start-2.months,start).count/100.0)).ceil
    end
    if level == "communal"
      c = Commune.find_by_postal_code(code)
      t = (3*(User.from_commune(c).logged_in_between(start-2.months,start).count/100.0)).ceil
    end
    if level == "provincial"
      p = Province.find_by_code(code)
      t = (3*(User.from_province(p).logged_in_between(start-2.months,start).count/100.0)).ceil
    end
    if level == "regional"
      r = Region.find_by_code(code)
      t = (3*(User.from_region(r).logged_in_between(start-2.months,start).count/100.0)).ceil
    end
    return [MIN_VALIDATION_THRESHOLD,t].max
  end
  
  scope :filter_keywords, lambda { |kw|
        where(["name_#{I18n.locale} LIKE ? OR content_#{I18n.locale} LIKE ?", "%#{kw}%", "%#{kw}%"])
  }
  
  scope :subdom_level, lambda { |subdom_level|
          if subdom_level.class.name == "Commune"
                  where(["level = ? AND level_code = ?", "Communal", subdom_level.postal_code])
          else 
                  if subdom_level.class.name == "Province"
                          where(["level = ? AND level_code = ?", "Provincial", subdom_level.code])
                  else
                          if subdom_level.class.name == "Region"
                                  where(["level = ? AND level_code = ?", "Regional", subdom_level.code])
                          else
                                  if subdom_level.class.name == "Community"
                                          joins(:community).
                                              where("communities.name = ?", subdom_level.name)
                                  else
                                          nil
                                  end
                          end
                  end
          end 
    }
  
  scope :user_geographical_level, lambda { |user, level|
    if level == 1
      where(["level = ? AND level_code = ?", level.to_s, user.commune.postal_code])
    else
      if level == 2
        where(["level = ? AND level_code = ?", level.to_s, user.province.code])
      else
        if level == 3
          where(["level = ? AND level_code = ?", level.to_s, user.region.code])
        else
          if level == 4
            where(["level = ?", level.to_s])
          else
            nil
          end
        end
      end
    end
  }
  
  scope :of_category, lambda {|categ|
    joins(:category).
    where("categories.name_#{I18n.locale} = ?", categ)
  }
  
  scope :all_validated, where(["validated = ?", true])
  
  scope :all_not_validated, where(["validated = ?", false])
  
  scope :not_blank, lambda { where(["content_#{I18n.locale} != ?", ""]) }
  
  attr_readonly :validations_count
  
  def time_elapsed
    Time.now()-self.created_at
  end
  
  def time_elapsed_since_validation
    if self.validation_date
      return Time.now()-self.validation_date
    else
      return time_elapsed
    end
  end
  
  def editing_time_elapsed
    time_elapsed
  end
  
  def validating_time_elapsed
    time_elapsed-BILL_EDITING_DURATION
  end
  
  def amending_time_elapsed
    time_elapsed_since_validation
  end
  
  def voting_time_elapsed
    time_elapsed_since_validation-BILL_AMENDMENTS_DURATION
  end
  
  def time_left_to_edit
    BILL_EDITING_DURATION-self.editing_time_elapsed
  end
  
  def time_left_to_validate
    BILL_VALIDATION_DURATION-self.validating_time_elapsed
  end
  
  def time_left_to_amend
    BILL_AMENDMENTS_DURATION-self.amending_time_elapsed
  end
  
  def time_left_to_vote
    BILL_VOTING_DURATION-self.voting_time_elapsed
  end
  
  def current_phase
    unless self.validated?
      if editing_time_elapsed < BILL_EDITING_DURATION
        return 1
      else
        if validating_time_elapsed < BILL_VALIDATION_DURATION
          return 2
        else
          return 0
        end
      end
    else
      if amending_time_elapsed < BILL_AMENDMENTS_DURATION
        return 3
      else
        if voting_time_elapsed < BILL_VOTING_DURATION
          return 4
        else
          return 5
        end
      end
    end
  end
  
  def self.filter_category(ar,*categ)
    list = []
    ar.each do |a|
      for cat in categ
        if !a.category.blank? && eval("a.category.name_#{I18n.locale}") == cat
          list << a
        end
      end
    end
    return list
  end
  
  def self.filter_phase(ar,*ph)
    list = []
    ar.each do |a|
      for phase in ph
        if a.current_phase == phase
          list << a
        end
      end
    end
    return list
  end
      
  def commune
    Commune.find_by_postal_code(self.level_code)
  end
  
  def province
    Province.find_by_code(self.level_code)
  end
  
  def region
    Region.find_by_code(self.level_code)
  end
end

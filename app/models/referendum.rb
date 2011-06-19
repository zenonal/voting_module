class Referendum < ActiveRecord::Base
  validates_length_of :content_en, :content_fr, :content_nl, :maximum=>4000
  acts_as_voteable
  if Rails.env=="development"
    has_attached_file :photo, :styles => {:small => "150x150>", :thumbnail => "80x80>"}
  else
    has_attached_file :photo, 
      :storage => :s3,
      :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
      :path => ":attachment/:id/:style.:extension",
      :url => ':s3_domain_url',
      :s3_permissions => 'authenticated-read',
      :s3_protocol => 'http',
      :styles => {:small => "150x150>", :thumbnail => "80x80>"}
  end
  
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :arguments, :as => :argumentable, :dependent => :destroy
  has_many :authorships
  has_many :politicians, :through => :authorships
  has_many :amendments, :as => :amendmentable, :dependent => :destroy
  has_many :rankings, :as => :rankable, :dependent => :destroy
  has_one :result, :as => :resultable, :dependent => :destroy
  belongs_to :category
  
  LEVELS = ["", I18n.t("referendums.level1"), I18n.t("referendums.level2"), I18n.t("referendums.level3"), I18n.t("referendums.level4")]
  PHASES = ["", I18n.t("referendums.phase3"),I18n.t("referendums.phase4"),I18n.t("referendums.phase5")]
  
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
  
  scope :not_blank, where(["content_#{I18n.locale} != \"\""])
  
  def time_elapsed
    Time.now()-self.created_at
  end
  
  def editing_time_elapsed
    time_elapsed
  end
  
  def amending_time_elapsed
    time_elapsed-BILL_EDITING_DURATION
  end
  
  def voting_time_elapsed
    time_elapsed-(BILL_EDITING_DURATION+BILL_AMENDMENTS_DURATION)
  end
  
  def time_left_to_edit
    BILL_EDITING_DURATION-self.editing_time_elapsed
  end
  
  def time_left_to_amend
    BILL_AMENDMENTS_DURATION-self.amending_time_elapsed
  end
  
  def time_left_to_vote
    BILL_VOTING_DURATION-self.voting_time_elapsed
  end
  
  def current_phase
    if editing_time_elapsed < BILL_EDITING_DURATION
      return 1
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
        if eval("a.category.name_#{I18n.locale}") == cat
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
    Commune.find_by_postal_code(self.user.postal_code).name
  end
  
  def province
    Commune.find_by_postal_code(self.user.postal_code).province.name
  end
  
  def region
    Commune.find_by_postal_code(self.user.postal_code).province.region.name
  end
  
  def validated?
    true
  end
end

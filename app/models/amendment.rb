class Amendment < ActiveRecord::Base
  validates_length_of :content_en, :content_fr, :content_nl, :maximum=>3000
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
      :styles => {:small => "150x150>", :thumbnail => "80x80>"}
  end
  
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :arguments, :as => :argumentable, :dependent => :destroy
  has_many :validations, :as => :validable, :dependent => :destroy
  has_one :brainstorm, :as => :brainstormable, :dependent => :destroy
  has_many :rankings, :as => :rankable, :dependent => :destroy
  has_many :weights, :as => :weightable, :dependent => :destroy
  has_one :result, :as => :resultable, :dependent => :destroy
  has_one :brainstorm, :as => :brainstormable, :dependent => :destroy
  belongs_to :user
  belongs_to :amendmentable, :polymorphic => true
  
  #tanker
    include Tanker
    tankit 'idx' do
        indexes :name_en
        indexes :name_fr
        indexes :name_nl
        indexes :content_en
        indexes :content_fr
        indexes :content_nl
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
  
  PHASES = ["", I18n.t("amendments.phase0"), I18n.t("amendments.phase1"),I18n.t("amendments.phase2"),I18n.t("amendments.phase3"),I18n.t("amendments.phase4"),I18n.t("amendments.phase5")]
  
  def validation_threshold
    t = MIN_VALIDATION_THRESHOLD
    start = self.created_at
    i = self.amendmentable
    level = i.level
    code = i.level_code
    if level.nil?
      t = (3*(User.logged_in_between(start-2.months.ago,start).count/100.0)).ceil
    end
    if level == "communal"
      c = Commune.find_by_postal_code(code)
      t = (3*(User.from_commune(c).logged_in_between(start-2.months.ago,start).count/100.0)).ceil
    end
    if level == "provincial"
      p = Province.find_by_code(code)
      t = (3*(User.from_province(p).logged_in_between(start-2.months.ago,start).count/100.0)).ceil
    end
    if level == "regional"
      r = Region.find_by_code(code)
      t = (3*(User.from_region(r).logged_in_between(start-2.months.ago,start).count/100.0)).ceil
    end
    return [MIN_VALIDATION_THRESHOLD,t].max
  end
  
  scope :all_validated, where(["validated = ?", true])
  
  scope :of_initiatives, where(["amendmentable_type = ?", "Initiative"])
  
  scope :of_referendums, where(["amendmentable_type = ?", "Referendum"])
  
  scope :all_not_validated, where(["validated = ?", false])
  
  scope :not_blank, where(["content_#{I18n.locale} != ''"])
  
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
    BILL_VOTING_DURATION-self.amendmentable.voting_time_elapsed
  end
  
  def current_phase
    original_phase = self.amendmentable.current_phase
    unless self.validated?
      if editing_time_elapsed < BILL_EDITING_DURATION
        return 1
      else
        #validation period ends when original bill passes to phase 4
        if original_phase < 4
          return 2
        else
          return 0
        end
      end
    else
      if original_phase == 4
        return 4
      else
        if original_phase == 5
          return 5
        else
          return 3
        end
      end
    end
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
  
end

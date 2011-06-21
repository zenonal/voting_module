# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
VotingModule::Application.initialize!

LANGUAGES = ["en","fr","nl"]

MIN_VALIDATION_THRESHOLD = 2
EXCLUSION_THRESHOLD = 5
BILL_VOTING_DURATION = 1.month
BILL_EDITING_DURATION = 1.week
BILL_AMENDMENTS_DURATION = 1.month
BILL_VALIDATION_DURATION = 1.month

INITIATIVE_LEVELS = ["", I18n.t("initiatives.level1"), I18n.t("initiatives.level2"), I18n.t("initiatives.level3"), I18n.t("initiatives.level4")]
INITIATIVE_PHASES = ["", I18n.t("initiatives.phase0"), I18n.t("initiatives.phase1"),I18n.t("initiatives.phase2"),I18n.t("initiatives.phase3"),I18n.t("initiatives.phase4"),I18n.t("initiatives.phase5")]
REFERENDUM_LEVELS = ["", I18n.t("referendums.level1"), I18n.t("referendums.level2"), I18n.t("referendums.level3"), I18n.t("referendums.level4")]
REFERENDUM_PHASES = ["", I18n.t("referendums.phase3"),I18n.t("referendums.phase4"),I18n.t("referendums.phase5")]

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
VotingModule::Application.initialize!

MIN_VALIDATION_THRESHOLD = 2
EXCLUSION_THRESHOLD = 5
BILL_VOTING_DURATION = 1.month
BILL_EDITING_DURATION = 1.week
BILL_AMENDMENTS_DURATION = 1.month
BILL_VALIDATION_DURATION = 1.month
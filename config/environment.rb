# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
VotingModule::Application.initialize!

VALIDATION_THRESHOLD = 1
EXCLUSION_THRESHOLD = 5
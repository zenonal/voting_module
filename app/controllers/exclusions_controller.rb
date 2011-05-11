class ExclusionsController < ApplicationController
  filter_resource_access
  before_filter :authenticate_user!
  
end

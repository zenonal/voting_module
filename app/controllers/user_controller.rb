class UserController < ApplicationController
  filter_resource_access
  before_filter :authenticate_user!, :except => [:show,:index]
  unless ENV['RAILS_ENV']=="development" 
  ssl_required :index, :show, :edit
  end
  
  def index
  end

  def show
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end

end

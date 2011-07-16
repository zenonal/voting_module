class DelegatesController < ApplicationController
  filter_resource_access
  before_filter :authenticate_user!, :except => [:index]
  unless ENV['RAILS_ENV']=="development" 
  ssl_required :new, :edit, :create, :update, :destroy, :index
  end
  
  # GET /delegates
  # GET /delegates.xml
  def index
    @delegates = Delegate.currently_active

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @delegates }
    end
  end

  # POST /delegates
  # POST /delegates.xml
  def create
    @delegate = Delegate.find_or_create_by_user_id(params[:user_id])
    @delegate.update_attribute(:active, true)
    @user = User.find_by_id(params[:user_id])
    respond_to do |format|
      if @delegate.save
        format.html { redirect_to(@user, :notice => 'Delegate was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @delegate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /delegates/1
  # DELETE /delegates/1.xml
  def destroy
    @delegate = Delegate.find_by_id(params[:id])
    @user = @delegate.user
    @delegate.update_attribute(:active, false)
    @delegate.delegations.each do |d|
            d.destroy
            DelegateMailer.delegation_forced_cancellation(d.user,@delegate).deliver
    end

    respond_to do |format|
      format.html { redirect_to(@user) }
      format.xml  { head :ok }
    end
  end
end

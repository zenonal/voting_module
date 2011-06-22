class DelegatesController < ApplicationController
  filter_resource_access
  before_filter :authenticate_user!, :except => [:index]
  
  # GET /delegates
  # GET /delegates.xml
  def index
    @delegates = Delegate.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @delegates }
    end
  end

  # POST /delegates
  # POST /delegates.xml
  def create
    @delegate = Delegate.new(:user_id => params[:user_id])
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
    @delegate.update_attribute(:user_id, nil)

    respond_to do |format|
      format.html { redirect_to(@user) }
      format.xml  { head :ok }
    end
  end
end

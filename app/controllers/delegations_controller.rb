class DelegationsController < ApplicationController
  filter_resource_access
  before_filter :authenticate_user!
  
  # POST /delegations
  # POST /delegations.xml
  def create
    @user = User.find_by_id(params[:user_id])
    
    unless @user.delegate == Delegate.find_by_id(params[:delegate_id])
      if @user.delegation.blank?
        @delegation = Delegation.new(:delegate_id => params[:delegate_id], :user_id => params[:user_id])
        @delegate = Delegate.find_by_id(params[:delegate_id]).user

        respond_to do |format|
          if @delegation.save
            format.html { redirect_to(@delegate, :notice => t('users.delegates.delegation_successful')) }
            format.xml  { render :xml => @delegate, :status => :created, :location => @delegate }
          else
            format.html { redirect_to(@delegate, :notice => t('users.delegates.already_added')) }
            format.xml  { render :xml => @delegation.errors, :status => :unprocessable_entity }
          end
        end
      else
        @delegation = @user.delegation
        @delegate = Delegate.find_by_id(params[:delegate_id]).user

        respond_to do |format|
          if @delegation.update_attribute(:delegate_id,params[:delegate_id])
            format.html { redirect_to(@delegate, :notice => t('users.delegates.delegation_successful')) }
            format.xml  { render :xml => @delegate, :status => :created, :location => @delegate }
          else
            format.html { redirect_to(@delegate, :notice => t('users.delegates.already_added')) }
            format.xml  { render :xml => @delegation.errors, :status => :unprocessable_entity }
          end
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to(@user, :notice => t('users.delegates.to_oneself')) }
        format.xml  { render :xml => @delegation.errors, :status => :unprocessable_entity }
      end
    end
    
  end

  # DELETE /delegations/1
  # DELETE /delegations/1.xml
  def destroy
    @delegation = Delegation.find(params[:id])
    @delegation.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.xml  { head :ok }
    end
  end
end

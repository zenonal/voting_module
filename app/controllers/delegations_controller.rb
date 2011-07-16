class DelegationsController < ApplicationController
  filter_resource_access
  before_filter :authenticate_user!
  unless ENV['RAILS_ENV']=="development" 
  ssl_required :create, :destroy
  end
  
  # POST /delegations
  # POST /delegations.xml
  def create
       
    @user = User.find_by_id(params[:user_id])
    
    unless @user.delegate == Delegate.find_by_id(params[:delegate_id])
      if @user.delegation.blank?
        @delegation = Delegation.new(:delegate_id => params[:delegate_id], :user_id => params[:user_id])
        @delegate = Delegate.find_by_id(params[:delegate_id]).user
        if @delegation.save
            redirect_to(@delegate, :notice => t('users.delegates.delegation_successful')) 
        else
            redirect_to(@delegate, :notice => t('users.delegates.already_added')) 
        end
      else
        @delegation = @user.delegation
        @delegate = Delegate.find_by_id(params[:delegate_id]).user.first

        if @delegation.update_attribute(:delegate_id,params[:delegate_id])
            redirect_to(@delegate, :notice => t('users.delegates.delegation_successful')) 
        else
            redirect_to(@delegate, :notice => t('users.delegates.already_added')) 
        end
      end
    else
      redirect_to(@user, :notice => t('users.delegates.to_oneself')) 
    end
   
  end

  # DELETE /delegations/1
  # DELETE /delegations/1.xml
  def destroy
    @delegation = Delegation.find(params[:id])
    @delegation.destroy

    respond_to do |format|
      format.html { redirect_to session[:jumpback]  }
      format.xml  { head :ok }
    end
  end
end

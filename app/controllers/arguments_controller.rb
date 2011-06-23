class ArgumentsController < ApplicationController
  filter_resource_access
  before_filter :authenticate_user!, :except => [:show,:index]
  unless ENV['RAILS_ENV']=="development" 
  ssl_required :show, :new, :edit, :create, :update, :destroy, :aye, :nay, :exclude_argument
  end
  

  def show
    @argumentable = @argument.argumentable_type.constantize.find_by_id(@argument.argumentable.id)
    @commentable = @argument
    @author = User.find_by_id(@argument.user_id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @referendum }
    end
  end
  
  # GET /arguments/1/edit
  def edit
    @argument = Argument.find(params[:id])
    @argumentable = find_argumentable
    @action = :update
  end

  def new
    @argument = Argument.new
    @argumentable = params[:argumentable].constantize.find(params[:argumentable_id])
    @action = :create

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @argument }
    end
  end
  
  # POST /arguments
  # POST /arguments.xml
  def create
    @argumentable = params[:argumentable].constantize.find(params[:argumentable_id])
    @argument = @argumentable.arguments.build(params[:argument])
    if verify_recaptcha()
      flash.delete(:recaptcha_error)
      if @argument.save
        @argument.update_attribute(:user_id, current_user.id)
        @argument.update_attribute(:language, I18n.locale)
        @argument.update_attribute(:pro, current_user.voted_for?(@argumentable))

        flash[:notice] = t(:new_argument_ok)
        redirect_to @argumentable

      else
        flash[:error] = t(:new_argument_not_ok)
        redirect_to(:controller => :arguments, :action => :new, :argumentable => @argumentable.class.name, :argumentable_id => @argumentable.id)
      end
    else
      flash.now[:alert] = t(:recaptcha_error)
      flash.delete(:recaptcha_error)
      render :action => "new"
    end
  end

  # PUT /arguments/1
  # PUT /arguments/1.xml
  def update
    @argumentable = params[:argumentable].constantize.find(params[:argumentable_id])
    @argument = Argument.find(params[:id])
    if verify_recaptcha()
      flash.delete(:recaptcha_error)
      respond_to do |format|
        if @argument.update_attributes(params[:argument])
          format.html { redirect_to(@argumentable, :notice => 'Argument was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @argument.errors, :status => :unprocessable_entity }
        end
      end
    else
      flash.now[:alert] = t(:recaptcha_error)
      flash.delete(:recaptcha_error)
      render :action => "edit"
    end
  end
  
  
  # DELETE /arguments/1
  # DELETE /arguments/1.xml
  def destroy
    @argument = Argument.find(params[:id])
    @argumentable = @argument.argumentable_type.constantize.find_by_id(@argument.argumentable_id)

    respond_to do |format|
      if @argument.destroy
        format.html { redirect_to(@argumentable, :notice => 'Argument was successfully deleted.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "delete" }
        format.xml  { render :xml => @argument.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def aye
     @argumentable = @argument.argumentable_type.constantize.find(@argument.argumentable_id)
     current_user.vote_for(@argument)
     redirect_to(@argument)
  end
  def nay
    @argumentable = @argument.argumentable_type.constantize.find(@argument.argumentable_id)
     current_user.vote_against(@argument)
     redirect_to(@argument)
  end
  
  def exclude_argument
    @exclusion = @argument.exclusions.find_or_create_by_user_id_and_excludable_id_and_excludable_type(current_user.id, @argument.id, "Argument")
    @argumentable = @argument.argumentable_type.constantize.find(@argument.argumentable_id)
    redirect_to(@argumentable)
  end
  
  def find_argumentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        na = $1.classify      
        return na.constantize.find(value)
      end
    end
    nil
  end
  
end

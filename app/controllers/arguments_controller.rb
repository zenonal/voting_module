class ArgumentsController < ApplicationController
  filter_resource_access
  before_filter :authenticate_user!, :except => [:show,:index]
  
  unless ENV['RAILS_ENV']=="development" 
    ssl_required  :create, :create_con, :destroy, :votefor, :voteagainst
  end
  

  # GET /arguments/1/edit
  def edit
    @argumentable = params[:argumentable].constantize.find(params[:argumentable_id])
    @argument = @argumentable.arguments.build(params[:argument])
  end

  # POST /arguments
  # POST /arguments.xml
  def create
    
    
     @argumentable = params[:argumentable].constantize.find(params[:argumentable_id])
     if params[:pro]
       @index = @argumentable.arguments.all_pros.size
     else
       @index = @argumentable.arguments.all_cons.size
     end
     @argument = @argumentable.arguments.build(params[:argument])
     
      if @argument.save
         @argument.update_attributes(:user_id => current_user.id, :pro => params[:pro])
         flash[:notice] = t(:new_argument_ok)
         respond_to do |format|
          format.html {redirect_to(@argumentable)}
          format.xml  { render :xml => @argumentable, :status => :created, :location => @argumentable }
          format.js { render :layout => false }
         end
         
      else
         flash[:error] = t(:new_argument_not_ok)
         redirect_to :id => nil
         
      end
  end

  # PUT /arguments/1
  # PUT /arguments/1.xml
  def update
    @argumentable = params[:argumentable].constantize.find(params[:argumentable_id])
    @argument = @argumentable.arguments.build(params[:argument])

    respond_to do |format|
      if @argument.update_attributes(params[:argument])
        format.html { redirect_to(@argumentable, :notice => 'Argument was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @argument.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /arguments/1
  # DELETE /arguments/1.xml
  def destroy
    @argumentable = params[:argumentable].constantize.find(params[:argumentable_id])
    @argument = @argumentable.arguments.build(params[:argument])
    @argument.destroy

    respond_to do |format|
      format.html { redirect_to(arguments_url) }
      format.xml  { head :ok }
    end
  end
end

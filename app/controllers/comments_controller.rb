class CommentsController < ApplicationController
  filter_resource_access
  before_filter :authenticate_user!, :except => [:show,:index]
  unless ENV['RAILS_ENV']=="development" 
    ssl_required  :index, :new, :show, :edit, :create, :create_reply, :update, :destroy, :reply_to_comment
  end
  
  # GET /comments
  # GET /comments.xml
  def index
    @commentable = find_commentable
    @comments = @commentable.comments

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @commentable = find_commentable
    @comment = @commentable.comments.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
     @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])

    respond_to do |format|
      if @comment.save
        @comment.update_attribute(:user_id, current_user.id)
        flash[:notice] = t(:new_comment_ok)
        format.html { redirect_to(@commentable) }
        format.xml  { render :xml => @commentable, :status => :created, :location => @commentable }
      else
        flash[:error] = t(:new_comment_not_ok)
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def create_reply
    @commentable = find_commentable
    @com = Comment.find(params[:id])
    @origin = @com.origin
    @back = @origin.commentable_type.constantize.find(@origin.commentable_id)
    
    if @com.reply_level < 5
    
      @reply = Comment.new(params[:reply])

      if @reply.save!
        @reply.update_attributes({:commentable_type => "Comment", :commentable_id => @com.id, :user_id => current_user.id})
       
        flash[:notice] = t(:new_comment_ok)
        redirect_to @back
        
      end
    end

    rescue ActiveRecord::RecordInvalid
      flash[:error] = t(:new_comment_not_ok)
      redirect_to @back
  end
  
  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to(@comment, :notice => 'Comment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @origin = @comment.origin
    @back = @origin.commentable_type.constantize.find(@origin.commentable_id)
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(@back) }
      format.xml  { head :ok }
    end
  end
  
  def reply_to_comment
    @com = Comment.find(params[:id])
    @author = User.find(@com.user_id).displayName
    @origin = @com.origin
    @back = @origin.commentable_type.constantize.find(@origin.commentable_id)
  end
  
  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        na = $1.classify      
        return na.constantize.find(value)
      end
    end
    nil
  end
end
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
    if verify_recaptcha()
      flash.delete(:recaptcha_error)
      @comment = @commentable.comments.build(params[:comment])

      respond_to do |format|
        if @comment.save
          @comment.update_attribute(:user_id, current_user.id)
          @comment.update_attribute(:language, I18n.locale)
          flash[:notice] = t(:new_comment_ok)
          format.html { redirect_to eval("#{@commentable.class.name.downcase}_path(@commentable)") }
          format.xml  { render :xml => @commentable, :status => :created, :location => @commentable }
        else
          flash[:error] = t(:new_comment_not_ok)
          format.html { redirect_to eval("#{@commentable.class.name.downcase}_path(@commentable)") }
          format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
        end
      end
    else
      flash.now[:alert] = t(:recaptcha_error)
      flash.delete(:recaptcha_error)
      redirect_to eval("#{@commentable.class.name.downcase}_path(@commentable)")
    end
  end

  def create_reply
    @commentable = find_commentable
    @com = Comment.find(params[:id])
    @origin = @com.origin
    @back = @origin.commentable_type.constantize.find(@origin.commentable_id)
    if verify_recaptcha()
      flash.delete(:recaptcha_error)
      if @com.reply_level < 5

        @reply = Comment.new(params[:reply])

        if @reply.save!
          @reply.update_attributes({:commentable_type => "Comment", :commentable_id => @com.id, :user_id => current_user.id, :language => I18n.locale})

          flash[:notice] = t(:new_comment_ok)
          redirect_to eval("#{@commentable.class.name.downcase}_path(@commentable)")
        else
          flash[:error] = t(:new_comment_not_ok)
          redirect_to eval("#{@commentable.class.name.downcase}_path(@commentable)")
        end
      end
    else
      flash.now[:alert] = t(:recaptcha_error)
      flash.delete(:recaptcha_error)
      redirect_to eval("#{@commentable.class.name.downcase}_path(@commentable)")
    end
  end
  
  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @commentable = find_commentable
    @comment = Comment.find(params[:id])
    if verify_recaptcha()
      flash.delete(:recaptcha_error)
      respond_to do |format|
        if @comment.update_attributes(params[:comment])
          format.html { redirect_to(eval("#{@commentable.class.name.downcase}_path(@commentable)"), :notice => 'Comment was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
        end
      end
    else
      flash.now[:alert] = t(:recaptcha_error)
      flash.delete(:recaptcha_error)
      render :action => "edit"
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
  
  
  def exclude_comment
    @exclusion = @comment.exclusions.find_or_create_by_user_id_and_excludable_id_and_excludable_type(current_user.id, @comment.id, "Comment")
    redirect_to(@comment.origin.commentable_type.constantize.find(@comment.origin.commentable_id))
  end
end

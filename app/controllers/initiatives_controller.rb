class InitiativesController < ApplicationController
  filter_resource_access
  before_filter :authenticate_user!, :except => [:show,:index]
  helper_method :filter_index
  
  # GET /initiatives
  # GET /initiatives.xml
  def index
    filter_index(Initiative.not_blank.validated)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @initiatives }
    end
  end
  
  def index_drafts
    @initiatives = Initiative.not_blank.not_validated
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :action => "index_drafts" }
    end
    
  end

  # GET /initiatives/1
  # GET /initiatives/1.xml
  def show
    @initiative = Initiative.find(params[:id])
    @commentable = @initiative
    if user_signed_in?
      deleg = Delegation.find_by_user_id(current_user.id)
        unless deleg.nil?
          unless deleg.delegate.voted_on?(@initiative)
            @delegated_vote = nil
          else
            @delegated_vote = deleg.delegate.voted_for?(@initiative)
          end
        else
          @delegated_vote = nil
        end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @initiative }
    end
  end

  # GET /initiatives/new
  # GET /initiatives/new.xml
  def new
    @initiative = Initiative.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @initiative }
    end
  end

  # GET /initiatives/1/edit
  def edit
    @initiative = Initiative.find(params[:id])
  end

  # POST /initiatives
  # POST /initiatives.xml
  def create
    
    @iinitiative = Initiative.find_or_create_by_content_en(params[:initiative])
    if @initiative
      for c in Category.all
        if params[eval("c.name_#{I18n.locale}")]
          @initiative.category = Category.find_or_create_by_name_en(c.name_en)
        end
      end

      @initiative.user = current_user
      if @initiative.level == "communal"
        @initiative.level_code = current_user.postal_code
      end
      if @initiative.level == "provincial"
        @initiative.level_code = current_user.province.code
      end
      if @initiative.level == "regional"
        @initiative.level_code = current_user.region.code
      end
      if @initiative.level == "federal"
        @initiative.level_code = 1
      end
      
      s = @initiative.save
    end
  
    respond_to do |format|
      if params[:preview_button] || !s
        format.html { render :action => "new" }
        format.xml  { render :xml => @initiative.errors, :status => :unprocessable_entity }
      else
        format.html { redirect_to(@initiative, :notice => 'Initiative was successfully created.') }
        format.xml  { render :xml => @initiative, :status => :created, :location => @initiative }
      end
    end
  end

  # PUT /initiatives/1
  # PUT /initiatives/1.xml
  def update
    @initiative = Initiative.find(params[:id])

    for c in Category.all
      if params[eval("c.name_#{I18n.locale}")]
        @initiative.category = Category.find_or_create_by_name_en(c.name_en)
      end
    end
    
    if @initiative.level == "communal"
      @initiative.level_code = @initiative.user.postal_code
    end
    if @initiative.level == "provincial"
      @initiative.level_code = @initiative.user.province.code
    end
    if @initiative.level == "regional"
      @initiative.level_code = @initiative.user.region.code
    end
    if @initiative.level == "federal"
      @initiative.level_code = 1
    end
    
    u = @initiative.update_attributes(params[:initiative])
    
    respond_to do |format|
      if  params[:preview_button] || !u
        format.html { render :action => "edit" }
        format.xml  { render :xml => @initiative.errors, :status => :unprocessable_entity }
      else
        format.html { redirect_to(@initiative, :notice => 'Initiative was successfully updated.') }
        format.xml  { head :ok }
      end
    end
  end

  # DELETE /initiatives/1
  # DELETE /initiatives/1.xml
  def destroy
    @initiative = Initiative.find(params[:id])
    if (current_user.roles[0].name=="admin") || !@initiative.validated?
      d= @initiative.destroy
    else
      d=nil
    end

    respond_to do |format|
      if d
        format.html { redirect_to(initiatives_url, :notice => 'Initiative was successfully destroyed.') }
        format.xml  { head :ok }
      else
        format.html { redirect_to(@initiative, :notice => 'You are not authorized to delete this initiative.') }
        format.xml  { head :ok }
      end
    end
  end
  
  
  def aye
     if params[:delegated]
       voter = current_user.delegate
     else
       voter = current_user
     end
     voter.vote_for(@initiative)
     @arg = @initiative.arguments.find_by_user_id(voter.id)
     if !@arg.nil?
       if @arg.pro==false
         @arg.update_attribute(:pro, true)
       end
     end
     redirect_to(@initiative)
  end
  def nay
     if params[:delegated]
        voter = current_user.delegate
      else
        voter = current_user
      end
     voter.vote_against(@initiative)
     @arg = @initiative.arguments.find_by_user_id(voter.id)
      if !@arg.nil?
        if @arg.pro==true
          @arg.update_attribute(:pro, false)
        end
      end
     redirect_to(@initiative)
  end
  
  def validate
    @initiative = Initiative.find(params[:id])
    unless !@initiative.validations.find_by_user_id(current_user.id).nil?
      Validation.create(:user_id => current_user.id, :validable_type => "Initiative",:validable_id => @initiative.id)
    end
    redirect_to(@initiative)
  end
  
  
end

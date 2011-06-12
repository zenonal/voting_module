class ReferendumsController < ApplicationController
  filter_resource_access
  before_filter :authenticate_user!, :except => [:show,:index]
  
  # GET /referendums
  # GET /referendums.xml
  def index
    @referendums = Referendum.all(:order => "created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @referendums }
    end
  end

  # GET /referendums/1
  # GET /referendums/1.xml
  def show
    @referendum = Referendum.find(params[:id])
    @commentable = @referendum
    if user_signed_in?
      deleg = Delegation.find_by_user_id(current_user.id)
        unless deleg.nil?
          unless deleg.delegate.voted_on?(@referendum)
            @delegated_vote = nil
          else
            @delegated_vote = deleg.delegate.voted_for?(@referendum)
          end
        else
          @delegated_vote = nil
        end
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @referendum }
    end
  end

  # GET /referendums/new
  # GET /referendums/new.xml
  def new
    @referendum = Referendum.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @referendum }
    end
  end

  # GET /referendums/1/edit
  def edit
    @referendum = Referendum.find(params[:id])
  end

  # POST /referendums
  # POST /referendums.xml
  def create
    @referendum = Referendum.new(params[:referendum])
    for p in Politician.all
      if params[p.name]
        @referendum.authorships << Authorship.find_or_create_by_politician_id(p.id)
      end
    end
    
    for c in Category.all
      if params[eval("c.name_#{I18n.locale}")]
        @referendum.category = Category.find_or_create_by_name_en(c.name_en)
      end
    end

    respond_to do |format|
      if @referendum.save
        format.html { redirect_to(@referendum, :notice => 'Referendum was successfully created.') }
        format.xml  { render :xml => @referendum, :status => :created, :location => @referendum }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @referendum.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /referendums/1
  # PUT /referendums/1.xml
  def update
    @referendum = Referendum.find(params[:id])
    for p in Politician.all
      if params[p.name]
        @referendum.authorships << Authorship.find_or_create_by_politician_id(p.id)
      end
    end
    
    for c in Category.all
      if params[eval("c.name_#{I18n.locale}")]
        @referendum.category = Category.find_or_create_by_name_en(c.name_en)
      end
    end

    respond_to do |format|
      if @referendum.update_attributes(params[:referendum])
        format.html { redirect_to(@referendum, :notice => 'Referendum was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @referendum.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /referendums/1
  # DELETE /referendums/1.xml
  def destroy
    @referendum = Referendum.find(params[:id])
    @referendum.destroy

    respond_to do |format|
      format.html { redirect_to(referendums_url) }
      format.xml  { head :ok }
    end
  end
  
  def aye
     if params[:delegated]
       voter = current_user.delegate
     else
       voter = current_user
     end
     voter.vote_for(@referendum)
     @arg = @referendum.arguments.find_by_user_id(voter.id)
     if !@arg.nil?
       if @arg.pro==false
         @arg.update_attribute(:pro, true)
       end
     end
     redirect_to(@referendum)
  end
  def nay
     if params[:delegated]
        voter = current_user.delegate
      else
        voter = current_user
      end
     voter.vote_against(@referendum)
     @arg = @referendum.arguments.find_by_user_id(voter.id)
      if !@arg.nil?
        if @arg.pro==true
          @arg.update_attribute(:pro, false)
        end
      end
     redirect_to(@referendum)
  end
  
end

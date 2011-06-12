class IdeasController < ApplicationController
  filter_resource_access
  before_filter :authenticate_user!, :except => [:show,:index]
  
  
  # GET /ideas
  # GET /ideas.xml
  def index
    @ideas = Idea.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ideas }
    end
  end

  # GET /ideas/new
  # GET /ideas/new.xml
  def new
    @idea = Idea.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @idea }
    end
  end

  # GET /ideas/1/edit
  def edit
    @idea = Idea.find(params[:id])
  end

  # POST /ideas
  # POST /ideas.xml
  def create
    @brainstorm = find_brainstorm
    @idea = @brainstorm.ideas.build(params[:idea])
    
    respond_to do |format|
      if @idea.save
        format.html { redirect_to(@brainstorm, :notice => 'Idea was successfully created.') }
        format.xml  { render :xml => @idea, :status => :created, :location => @idea }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @idea.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ideas/1
  # PUT /ideas/1.xml
  def update
    @brainstorm = find_brainstorm
    @idea = Idea.find(params[:id])

    respond_to do |format|
      if @idea.update_attributes(params[:idea])
        format.html { redirect_to(@idea, :notice => 'Idea was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @idea.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ideas/1
  # DELETE /ideas/1.xml
  def destroy
    @idea = Idea.find(params[:id])
    @idea.destroy

    respond_to do |format|
      format.html { redirect_to(ideas_url) }
      format.xml  { head :ok }
    end
  end
  
  def find_brainstorm
    params.each do |name, value|
      if name =~ /(.+)_id$/
        na = $1.classify    
        brainstorm = na.constantize.find(value)
        return brainstorm
      end
    end
    nil
  end
  
  def aye
     current_user.vote_for(@idea)
     redirect_to(@idea.brainstorm)
  end
  def nay
     current_user.vote_against(@idea)
     redirect_to(@idea.brainstorm)
  end
  
  def exclude_idea
    @exclusion = @idea.exclusions.find_or_create_by_user_id_and_excludable_id_and_excludable_type(current_user.id, @idea.id, "Argument")
    @brainstorm = @idea.brainstorm
    redirect_to(@brainstorm)
  end
end

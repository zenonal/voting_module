class BrainstormsController < ApplicationController
  filter_access_to :all
  before_filter :authenticate_user!, :except => [:show,:index]
  
  # GET /brainstorms
  # GET /brainstorms.xml
  def index
    @brainstorms = Brainstorm.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @brainstorms }
    end
  end

  # GET /brainstorms/1
  # GET /brainstorms/1.xml
  def show
    @brainstorm = find_brainstorm
    if @brainstorm.nil?
      @brainstorm = Brainstorm.find_by_id(params[:id])
    end
    @ideas = @brainstorm.ideas
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @brainstorm }
    end
  end
  
  def find_brainstorm
    params.each do |name, value|
      if name =~ /(.+)_id$/
        na = $1.classify    
        brainstormable = na.constantize.find(value)
        brainstorm = Brainstorm.find_or_create_by_brainstormable_id_and_brainstormable_type(brainstormable.id, brainstormable.class.name)
        return brainstorm
      end
    end
    nil
  end
end

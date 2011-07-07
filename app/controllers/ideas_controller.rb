class IdeasController < ApplicationController
  filter_resource_access
  before_filter :authenticate_user!, :except => [:show,:index]
  unless ENV['RAILS_ENV']=="development" 
  ssl_required :index, :index_all, :select_ideas, :create, :destroy, :aye, :nay, :exclude_idea
  end
  
  # GET /ideas
  # GET /ideas.xml
  def index
    @brainstorm = find_brainstorm
    @bill = @brainstorm.brainstormable
    @ideas = current_user.ideas.for_bill(@bill).not_blank

    respond_to do |format|
      format.html
      format.js
    end
  end
  
  # GET /ideas
    # GET /ideas.xml
    def index_all
      @brainstorm = find_brainstorm
      @bill = @brainstorm.brainstormable
      @ideas = @brainstorm.ideas.not_blank.sort {|a,b| (b.votes_for-b.votes_against) <=> (a.votes_for-a.votes_against) }
      
      respond_to do |format|
        format.html
        format.js
      end
    end
  
  # GET /ideas
  # GET /ideas.xml
  def select_ideas
    @brainstorm = find_brainstorm
    @bill = @brainstorm.brainstormable
    @ideas = @brainstorm.ideas.not_from_user(current_user).not_blank.shuffle.first(10)
    
     respond_to do |format|
        format.html
        format.js
      end
  end
  
  # POST /ideas
  # POST /ideas.xml
  def create
    @brainstorm = find_brainstorm
    @bill = @brainstorm.brainstormable
    @idea = @brainstorm.ideas.build(params[:idea])
    @idea.user_id = current_user.id
    
    respond_to do |format|
      if @idea.save
        flash[:notice] = t('brainstorms.idea_succesful')
        format.html { redirect_to(@brainstorm, :notice => 'Idea was successfully created.') }
        format.xml  { render :xml => @idea, :status => :created, :location => @idea }
        format.js
      else
        flash[:notice] = t('brainstorms.idea_unsuccesful')
        format.html { render :action => "new" }
        format.xml  { render :xml => @idea.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /ideas/1
  # DELETE /ideas/1.xml
  def destroy
    @brainstorm = find_brainstorm
    @bill = @brainstorm.brainstormable
    @idea = Idea.find(params[:id])
    @idea.destroy

    respond_to do |format|
      format.html { redirect_to(ideas_url) }
      format.xml  { head :ok }
      format.js
    end
  end
  
  def find_brainstorm
    params.each do |name, value|
      if name =~ /(.+)_id$/
        na = $1.classify    
        if na == "Brainstorm"
                brainstorm = Brainstorm.find(value)
        end 
        if na == "Initiative"
                bill = Initiative.find(value)
                if bill.brainstorm.nil?
                        brainstorm = bill.build_brainstorm
                        brainstorm.save!
                else
                        brainstorm = bill.brainstorm
                end
        end
        if na == "Referendum"
                bill = Referendum.find(value)
                if bill.brainstorm.nil?
                        brainstorm = bill.build_brainstorm
                        brainstorm.save!
                else
                        brainstorm = bill.brainstorm
                end
        end
        if na == "Amendment"
                bill = Amendment.find(value)
                if bill.brainstorm.nil?
                        brainstorm = bill.build_brainstorm
                        brainstorm.save!
                else
                        brainstorm = bill.brainstorm
                end
        end
        return brainstorm
      end
    end
    nil
  end
  
  def aye
     unless current_user == @idea.user
             current_user.vote_for(@idea)
             respond_to do |format|
                     format.html {redirect_to(:action => :select_idea)}
                     format.js
             end
     else
             flash[:notice] = t('brainstorms.not_own_bill')
             respond_to do |format|
                          format.html {redirect_to(:action => :select_idea)}
                          format.js
             end
     end
  end
  def nay
     unless current_user == @idea.user
        current_user.vote_against(@idea)
        respond_to do |format|
             format.html {redirect_to(:action => :select_idea)}
             format.js
        end
     else
             flash[:notice] = t('brainstorms.not_own_bill')
             respond_to do |format|
                  format.html {redirect_to(:action => :select_idea)}
                  format.js
             end
     end
  end
  
  def exclude_idea
    @exclusion = @idea.exclusions.find_or_create_by_user_id_and_excludable_id_and_excludable_type(current_user.id, @idea.id, "Argument")
    @brainstorm = @idea.brainstorm
    redirect_to(@brainstorm)
  end
end

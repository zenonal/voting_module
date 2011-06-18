class AmendmentsController < ApplicationController
  filter_resource_access
  before_filter :authenticate_user!, :except => [:show,:index]
  
  # GET /amendments
  # GET /amendments.xml
  def index
    filter_index(Amendment.not_blank)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @amendments }
    end
  end
  
  # GET /amendments/1
  # GET /amendments/1.xml
  def show
    @amendment = Amendment.find(params[:id])
    @amendmentable = extract_amendmentable(@amendment)
    if (@amendment.current_phase == 5) 
      if @amendment.result.nil?
        w = Ranking.schulze(@amendment)
        Ranking.all_related_bills(@amendment).each_with_index do |b,index|
          if w == index+1
            b.create_result(:condorcet_winner => w, :winner => true)
          else
            b.create_result(:condorcet_winner => w, :winner => false)
          end
        end
        @winner = w
      else
        @winner = @amendment.result.condorcet_winner
      end
      
    end
    
    if user_signed_in?
      @deleg = Delegation.find_by_user_id(current_user.id)
        unless @deleg.nil?
          unless Ranking.ranked_on?(@deleg.delegate,@amendment)
            @delegated_vote = nil
          else
            @delegated_vote = Ranking.all_related_bills_sorted(@amendment,@deleg.delegate)
          end
        else
          @delegated_vote = nil
        end
    else
             @delegated_vote = nil
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @amendment }
    end
  end

  # GET /amendments/new
  # GET /amendments/new.xml
  def new
    @amendment = Amendment.new
    @amendmentable = find_amendmentable
    if (@amendmentable.current_phase == 3)
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @amendment }
      end
    else
      redirect_to(@amendmentable)
    end
  end

  # GET /amendments/1/edit
  def edit
    @amendment = Amendment.find(params[:id])
    @amendmentable = find_amendmentable
    unless (@amendment.current_phase == 1)
      redirect_to(@amendment)
    end
  end

  # POST /amendments
  # POST /amendments.xml
  def create
    @amendmentable = find_amendmentable
    if (@amendmentable.current_phase == 3)

      @amendment = Amendment.find_by_content_en(params[:amendment][:content_en])
      if @amendment
        s = @amendment.update_attributes(params[:amendment])
      else
        @amendment = @amendmentable.amendments.build(params[:amendment])
        @amendment.user = current_user
        s = @amendment.save
      end

      respond_to do |format|
        if params[:preview_button] || !s
          format.html { render :action => "new" }
          format.xml  { render :xml => @amendment.errors, :status => :unprocessable_entity }
        else
          format.html { redirect_to(@amendment, :notice => 'Amendment was successfully created.') }
          format.xml  { render :xml => @amendment, :status => :created, :location => @amendment }
        end
      end
    else
      redirect_to(@amendmentable)
    end
  end

  # PUT /amendments/1
  # PUT /amendments/1.xml
  def update
    @amendment = Amendment.find(params[:id])

    if (current_user.roles[0].name=="admin") || (@amendment.current_phase == 1)
      respond_to do |format|
        if  params[:preview_button] || !@amendment.update_attributes(params[:amendment])
          format.html { render :action => "edit" }
          format.xml  { render :xml => @amendment.errors, :status => :unprocessable_entity }
        else
          format.html { redirect_to(@amendment, :notice => 'Amendment was successfully updated.') }
          format.xml  { head :ok }
        end
      end
    else
      redirect_to(@amendment)
    end
  end

  # DELETE /amendments/1
  # DELETE /amendments/1.xml
  def destroy
    @amendment = Amendment.find(params[:id])
    if (current_user.roles[0].name=="admin") || (@amendment.current_phase == 1)
      @amendmentable = extract_amendmentable(@amendment)
      if (current_user.roles[0].name=="admin") || !@amendment.validated?
        d= @amendment.destroy
      else
        d=nil
      end

      respond_to do |format|
        if d
          format.html { redirect_to(@amendmentable, :notice => 'Amendment was successfully destroyed.') }
          format.xml  { head :ok }
        else
          format.html { redirect_to(@amendmentable, :notice => 'You are not authorized to delete this amendment.') }
          format.xml  { head :ok }
        end
      end
    else
      redirect_to(@amendment)
    end
  end
  
  def vote
    a = Amendment.find(params[:id])
    @initiative = a.amendmentable
    @amendments = @initiative.amendments.not_blank.all_validated
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @initiative }
    end
  end
  
  def show_results
    a = Amendment.find(params[:id])
    @initiative = a.amendmentable
    @amendments = @initiative.amendments.not_blank.all_validated
    if @initiative.current_phase == 5
      if @initiative.result.nil? 
  	    @initiative.result.build(:condorcet_winner => Ranking.schulze(@initiative))
	    end
    end
    @winner = @initiative.result.condorcet_winner
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @initiative }
    end
  end
  
  def aye
    if @amendment.current_phase == 4
      if params[:delegated]
        voter = current_user.delegate
      else
        voter = current_user
      end
      voter.vote_for(@amendment)
      @arg = @amendment.arguments.find_by_user_id(voter.id)
      if !@arg.nil?
        if @arg.pro==false
          @arg.update_attribute(:pro, true)
        end
      end
    end
    redirect_to(@amendment)
  end
  def nay
    if @amendment.current_phase == 4
      if params[:delegated]
        voter = current_user.delegate
      else
        voter = current_user
      end
      voter.vote_against(@amendment)
      @arg = @amendment.arguments.find_by_user_id(voter.id)
      if !@arg.nil?
        if @arg.pro==true
          @arg.update_attribute(:pro, false)
        end
      end
    end
    redirect_to(@amendment)
  end
  def validate
    if @amendment.current_phase == 2
      @amendment = Amendment.find(params[:id])
      unless !@amendment.validations.find_by_user_id(current_user.id).nil?
        Validation.create(:user_id => current_user.id, :validable_type => "Amendment", :validable_id => @amendment.id)
      end
    end
    redirect_to(@amendment)
  end
  
  private
  def find_amendmentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        na = $1.classify      
        return na.constantize.find(value)
      end
    end
    nil
  end
  def extract_amendmentable(source)
    return source.amendmentable_type.constantize.find_by_id(source.amendmentable_id)
  end
end

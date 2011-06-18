class InitiativesController < ApplicationController
  filter_resource_access
  before_filter :authenticate_user!, :except => [:show,:index]
  helper_method :filter_index
  
  # GET /initiatives
  # GET /initiatives.xml
  def index
    restart_tutorial
    filter_index(Initiative.not_blank)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @initiatives }
    end
  end

  # GET /initiatives/1
  # GET /initiatives/1.xml
  def show
    restart_tutorial
    if (@initiative.current_phase == 5) 
      if @initiative.result.nil?
        w = Ranking.schulze(@initiative)
        Ranking.all_related_bills(@initiative).each_with_index do |b,index|
          r = b.result.find_or_create_by_condorcet_winner(w)
          if w == index+1
            r.update_attribute(:winner,true)
          else
            r.update_attribute(:winner,false)
          end
        end
        @winner = w
      else
        @winner = @initiative.result.condorcet_winner
      end
    end
    @initiative = Initiative.find(params[:id])
    
    if user_signed_in?
      @deleg = Delegation.find_by_user_id(current_user.id)
        unless @deleg.nil?
          unless Ranking.ranked_on?(@deleg.delegate,@initiative)
            @delegated_vote = nil
          else
            @delegated_vote = Ranking.all_related_bills_sorted(@initiative,@deleg.delegate)
          end
        else
          @delegated_vote = nil
        end
    else
         @delegated_vote = nil
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @initiative }
    end
  end

  # GET /initiatives/new
  # GET /initiatives/new.xml
  def new
    restart_tutorial
    @initiative = Initiative.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @initiative }
    end
  end

  # GET /initiatives/1/edit
  def edit
    restart_tutorial
    @initiative = Initiative.find(params[:id])
    unless (@initiative.current_phase == 1)
      redirect_to(@initiative)
    end
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
      if @initiative.level == 1
        @initiative.level_code = current_user.postal_code
      end
      if @initiative.level == 2
        @initiative.level_code = current_user.province.code
      end
      if @initiative.level == 3
        @initiative.level_code = current_user.region.code
      end
      if @initiative.level == 4
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
    if (current_user.roles[0].name=="admin") || (@initiative.current_phase == 1)
      @initiative = Initiative.find(params[:id])

      for c in Category.all
        if params[eval("c.name_#{I18n.locale}")]
          @initiative.category = Category.find_or_create_by_name_en(c.name_en)
        end
      end

      if @initiative.level == 1
        @initiative.level_code = @initiative.user.postal_code
      end
      if @initiative.level == 2
        @initiative.level_code = @initiative.user.province.code
      end
      if @initiative.level == 3
        @initiative.level_code = @initiative.user.region.code
      end
      if @initiative.level == 4
        @initiative.level_code = 1
      end

      u = @initiative.update_attributes(params[:initiative])
    else
      u = false
    end

    if  params[:preview_button] || !u
      render :action => "edit"
    else
      redirect_to(@initiative, :notice => 'Initiative was successfully updated.')
    end

  end

  # DELETE /initiatives/1
  # DELETE /initiatives/1.xml
  def destroy
    @initiative = Initiative.find(params[:id])
    if (current_user.roles[0].name=="admin") || (@initiative.current_phase == 1)
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
  
  def vote
    @initiative = Initiative.find(params[:id])
    @amendments = @initiative.amendments.not_blank.all_validated
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @initiative }
    end
  end
  
  def show_results
    @initiative = Initiative.find(params[:id])
    if @initiative.current_phase == 5
      @amendments = @initiative.amendments.not_blank.all_validated
      @winner = @initiative.result.condorcet_winner
      @matrix = Ranking.rank_matrix(@initiative)

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @initiative }
      end
    else
      redirect_to @initiative
    end
  end
  
  def ranking
    @initiative = Initiative.find(params[:id])
    @amendments = @initiative.amendments.not_blank.all_validated
    @parsed_json = ActiveSupport::JSON.decode(params[:rankings])
    rank = []
    if params[:delegated]
      user_id = current_user.delegate.id
      user_type = "Delegate"
    else
      user_id = current_user.id
      user_type = "User"
    end
    rank[0] = @initiative.rankings.
      find_or_create_by_rankable_id_and_ranker_id_and_rankable_type_and_ranker_type(@initiative.id,user_id,"Initiative",user_type)
    rank[0].update_attribute(:rank, @parsed_json[0])
    @amendments.each_with_index do |a, index|
      rank[index+1] = a.rankings.
        find_or_create_by_rankable_id_and_ranker_id_and_rankable_type_and_ranker_type(a.id,user_id,"Amendment",user_type)
      rank[index+1].update_attribute(:rank, @parsed_json[index+1])
    end

    respond_to do |format|
      format.html { redirect_to initiative_url(@initiative,:rankings => @parsed_json) }
      format.js { render(:update) { |page| page.redirect_to initiative_url(@initiative,:rankings => @parsed_json)}}
    end
  end
  
  def aye
     if @initiative.current_phase == 4
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
     end
     redirect_to(@initiative)
  end
  def nay
    if @initiative.current_phase == 4
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
    end
     redirect_to(@initiative)
  end
  
  def validate
    @initiative = Initiative.find(params[:id])
    if @initiative.current_phase == 2
      unless !@initiative.validations.find_by_user_id(current_user.id).nil?
        Validation.create(:user_id => current_user.id, :validable_type => "Initiative",:validable_id => @initiative.id)
      end
    end
    redirect_to(@initiative)
  end
  
end

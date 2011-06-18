class ReferendumsController < ApplicationController
  filter_resource_access
  before_filter :authenticate_user!, :except => [:show,:index]
  
  # GET /referendums
  # GET /referendums.xml
  def index
    filter_index(Referendum.not_blank)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @referendums }
    end
  end

  # GET /referendums/1
  # GET /referendums/1.xml
  def show
    @referendum = Referendum.find(params[:id])
    if (@referendum.current_phase == 5) 
      if @referendum.result.nil?
        w = Ranking.schulze(@referendum)
        Ranking.all_related_bills(@referendum).each_with_index do |b,index|
          r = b.result.find_or_create_by_condorcet_winner(w)
          if w == index+1
            r.update_attribute(:winner,true)
          else
            r.update_attribute(:winner,false)
          end
        end
        @winner = w
      else
        @winner = @referendum.result.condorcet_winner
      end
    end
    @commentable = @referendum
    if user_signed_in?
      @deleg = Delegation.find_by_user_id(current_user.id)
        unless @deleg.nil?
          unless Ranking.ranked_on?(@deleg.delegate,@referendum)
            @delegated_vote = nil
          else
            @delegated_vote = Ranking.all_related_bills_sorted(@referendum,@deleg.delegate)
          end
        else
          @delegated_vote = nil
        end
    else
        @delegated_vote = nil
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
    unless (current_user.roles[0].name=="admin") || (@referendum.current_phase == 1)
      redirect_to(@referendum)
    end
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
    
    if @referendum.level == 1
      @referendum.level_code = current_user.postal_code
    end
    if @referendum.level == 2
      @referendum.level_code = current_user.province.code
    end
    if @referendum.level == 3
      @referendum.level_code = current_user.region.code
    end
    if @referendum.level == 4
      @referendum.level_code = 1
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
    if (current_user.roles[0].name=="admin") || (@referendum.current_phase == 1)
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

      if @referendum.level == 1
        @referendum.level_code = current_user.postal_code
      end
      if @referendum.level == 2
        @referendum.level_code = current_user.province.code
      end
      if @referendum.level == 3
        @referendum.level_code = current_user.region.code
      end
      if @referendum.level == 4
        @referendum.level_code = 1
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
    else
      redirect_to(@referendum)
    end
  end

  # DELETE /referendums/1
  # DELETE /referendums/1.xml
  def destroy
    @referendum = Referendum.find(params[:id])
    if (current_user.roles[0].name=="admin") || (@referendum.current_phase == 1)
      @referendum.destroy

      respond_to do |format|
        format.html { redirect_to(referendums_url) }
        format.xml  { head :ok }
      end
    else
      redirect_to(@referendum)
    end
  end
  
  
  def vote
    @referendum = Referendum.find(params[:id])
    @amendments = @referendum.amendments.not_blank.all_validated
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @referendum }
    end
  end
  
  def show_results
    @referendum = Referendum.find(params[:id])
    if @referendum.current_phase == 5
      @amendments = @referendum.amendments.not_blank.all_validated
      @winner = @referendum.result.condorcet_winner
      @matrix = Ranking.rank_matrix(@referendum)
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @referendum }
      end
    else
        redirect_to @initiative
    end
  end
  
  def ranking
    @referendum = Referendum.find(params[:id])
    @amendments = @referendum.amendments.not_blank.all_validated
    @parsed_json = ActiveSupport::JSON.decode(params[:rankings])
    rank = []
    if params[:delegated] && current_user.delegate
      user_id = current_user.delegate.id
      user_type = "Delegate"
    else
      user_id = current_user.id
      user_type = "User"
    end
    rank[0] = @referendum.rankings.
      find_or_create_by_rankable_id_and_ranker_id_and_rankable_type_and_ranker_type(@referendum.id,user_id,"Referendum",user_type)
    rank[0].update_attribute(:rank, @parsed_json[0])
    @amendments.each_with_index do |a, index|
      rank[index+1] = a.rankings.
        find_or_create_by_rankable_id_and_ranker_id_and_rankable_type_and_ranker_type(a.id,user_id,"Amendment",user_type)
      rank[index+1].update_attribute(:rank, @parsed_json[index+1])
    end

    respond_to do |format|
      format.html { redirect_to referendum_url(@referendum,:rankings => @parsed_json) }
      format.js { render(:update) { |page| page.redirect_to referendum_url(@referendum,:rankings => @parsed_json)}}
    end
  end
  
  def aye
    if @referendum.current_phase == 4
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
    end
    redirect_to(@referendum)
  end
  def nay
    if @referendum.current_phase == 4
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
    end
     redirect_to(@referendum)
  end
  
end

class ReferendumsController < ApplicationController
  filter_resource_access
  before_filter :authenticate_user!, :except => [:show,:index]
  unless ENV['RAILS_ENV']=="development" 
  ssl_required :show, :new, :edit, :create, :update, :destroy, :vote, :show_results, :ranking, :aye, :nay
  end
  
  # GET /referendums
  # GET /referendums.xml
  def index
    filter_index(Referendum.not_blank)
    @categories = [""] + Category.all.collect {|l| [eval("l.name_#{I18n.locale}")]}
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @referendums }
    end
  end

  # GET /referendums/1
  # GET /referendums/1.xml
  def show
    if (@referendum.current_phase == 5) 
      if @referendum.result.nil?
        w = Ranking.schulze(@referendum)
        Ranking.all_related_bills(@referendum).each_with_index do |b,index|
          r = b.build_result(:condorcet_winner => w)
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
    if @referendum.brainstorm
        @ideas = @referendum.brainstorm.ideas.not_blank.sort {|a,b| (b.votes_for-b.votes_against) <=> (a.votes_for-a.votes_against) }.first
    else
        @ideas = nil
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @referendum }
    end
  end

  # GET /referendums/new
  # GET /referendums/new.xml
  def new
    @not_lang = not_current_languages

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @referendum }
    end
  end

  # GET /referendums/1/edit
  def edit
    @not_lang = not_current_languages
    
    unless (current_user.roles[0].name=="admin") || (@referendum.current_phase == 1)
      redirect_to(@referendum)
    end
  end

  # POST /referendums
  # POST /referendums.xml
  def create
    @not_lang = not_current_languages
    if @referendum && verify_recaptcha()
      flash.delete(:recaptcha_error)

      if @referendum
        for p in Politician.all
          if params[p.name]
            @referendum.authorships << Authorship.find_or_create_by_politician_id(p.id)
          end
        end
        if params[:category] && !params[:category].empty?
                @referendum.category = Category.find_by_name_en(params[:category])
        end

        if @referendum.level == "1"
          @referendum.level_code = current_user.commune.postal_code
        end
        if @referendum.level == "2"
          @referendum.level_code = current_user.province.code
        end
        if @referendum.level == "3"
          @referendum.level_code = current_user.region.code
        end
        if @referendum.level == "4"
          @referendum.level_code = 1
        end

        s = @referendum.save
      else
        s=false
      end

      respond_to do |format|
        if params[:preview_button] || !s
          format.html { render :action => "new" }
          format.xml  { render :xml => @referendum.errors, :status => :unprocessable_entity }
        else
          BillMailer.bill_creation_confirmation(current_user,@referendum).deliver
          format.html { redirect_to(@referendum, :notice => t("referendums.created")) }
          format.xml  { render :xml => @referendum, :status => :created, :location => @referendum }
        end
      end
    else
      flash.now[:alert] = t(:recaptcha_error)
      flash.delete(:recaptcha_error)
      render :action => "new"
    end
  end

  # PUT /referendums/1
  # PUT /referendums/1.xml
  def update
    @not_lang = not_current_languages
    if @referendum && verify_recaptcha()
      flash.delete(:recaptcha_error)

      if (current_user.roles[0].name=="admin") || (@referendum.current_phase == 1)
        if params[:referendum][:photo] && params[:referendum][:photo] == ""
           params[:referendum].delete :photo
        end
        u = @referendum.update_attributes(params[:referendum])
        @referendum.update_attribute(:category, Category.find_by_name_en(params[:category]))
        @referendum.authorships = []
        for p in Politician.all
          if params[p.name]
            @referendum.authorships << Authorship.find_or_create_by_politician_id(p.id)
          end
        end

        l=true
        if @referendum.level == "1"
          l = @referendum.update_attribute(:level_code, @referendum.user.commune.postal_code)
        end
        if @referendum.level == "2"
          l = @referendum.update_attribute(:level_code, @referendum.user.province.code)
        end
        if @referendum.level == "3"
          l = @referendum.update_attribute(:level_code, @referendum.user.region.code)
        end
        if @referendum.level == "4"
          l = @referendum.update_attribute(:level_code, 1)
        end
      else
        u = false
      end
      u = u&l

      if  params[:preview_button] || !u
        render :action => "edit"
      else
        redirect_to(@referendum, :notice => t("referendums.created"))
      end
    else
      flash.now[:alert] = t(:recaptcha_error)
      flash.delete(:recaptcha_error)
      render :action => "edit"
    end
  end

  # DELETE /referendums/1
  # DELETE /referendums/1.xml
  def destroy
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
    @amendments = @referendum.amendments.not_blank.all_validated
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @referendum }
    end
  end
  
  def show_results
    if @referendum.current_phase == 5
      @amendments = @referendum.amendments.not_blank.all_validated
      @winner = @referendum.result.condorcet_winner
      @matrix = Ranking.rank_matrix(@referendum)
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @referendum }
      end
    else
        redirect_to @referendum
    end
  end
  
  def ranking
    @amendments = @referendum.amendments.not_blank.all_validated
    @parsed_json = ActiveSupport::JSON.decode(params[:rankings])
    rank = []
    if (params[:delegated] == "true") && current_user.delegate
      user_id = current_user.delegate.id
      user_type = "Delegate"
      if @referendum.rankings.for_ranker(current_user.delegate).empty? || @referendum.rankings.for_ranker(current_user.delegate).nil?
              allowed = true
      else
              allowed = @referendum.rankings.for_ranker(current_user.delegate).first.created_at > (Time.now()-1.day)
      end
    else
      user_id = current_user.id
      user_type = "User"
      allowed = true
    end
    if allowed
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
    else
      respond_to do |format|
        format.html { redirect_to referendum_url(@referendum,:rankings => @parsed_json) }
        format.js { render(:update) { |page| page.redirect_to referendum_url(@referendum,:rankings => @parsed_json)}
                    flash[:alert] = t("referendums.not_allowed")
        }
      end
      
    end 
    
  end
  
  def aye
    if @referendum.current_phase == 4
      if (params[:delegated] == "true")
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
     if (params[:delegated] == "true")
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

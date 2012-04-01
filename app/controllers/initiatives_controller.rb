class InitiativesController < ApplicationController
  filter_resource_access
  before_filter :authenticate_user!, :except => [:show,:index]
  helper_method :filter_index
  
  # GET /initiatives
  # GET /initiatives.xml
  def index
    @categories = [""] + Category.all.collect {|l| [eval("l.name_#{I18n.locale}")]}
    filter_index(Initiative.not_blank)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @initiatives }
    end
  end

  # GET /initiatives/1
  # GET /initiatives/1.xml
  def show
    if (@initiative.current_phase == 5) 
      if @initiative.result.nil?
        w = Ranking.schulze(@initiative)
        Ranking.all_related_bills(@initiative).each_with_index do |b,index|
          r = b.build_result(:condorcet_winner => w)
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
    if @initiative.brainstorm
        @ideas = @initiative.brainstorm.ideas.not_blank.sort {|a,b| (b.votes_for-b.votes_against) <=> (a.votes_for-a.votes_against) }.first
    else
        @ideas = nil
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
    @not_lang = not_current_languages

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @initiative }
    end
  end

  # GET /initiatives/1/edit
  def edit
    @initiative = Initiative.find(params[:id])
    @not_lang = not_current_languages
    
    unless (@initiative.current_phase == 1 || current_user.roles.first.name == "admin")
      redirect_to(@initiative)
    end
  end

  # POST /initiatives
  # POST /initiatives.xml
  def create
    @not_lang = not_current_languages
    if @initiative && verify_recaptcha()
      flash.delete(:recaptcha_error)
      if params[:category] && !params[:category].empty?
          @initiative.category = eval("Category.find_by_name_#{I18n.locale}(params[:category])")
      end
      if @subdom_level.class.name == "Community"
              c = Community.find_by_name(@subdom_level.name)
              if !c.empty?
                      @initiative.community = c
              else
                      c = Community.find_by_name("3D")
                      if !c.empty?
                              @initiative.community = c
                      end
              end
      else
              c = Community.find_by_name("3D")
              if !c.empty?
                      @initiative.community = c
              end
      end
      
      @initiative.user = current_user
      if @initiative.level == "1"
        @initiative.level_code = current_user.commune.postal_code
      end
      if @initiative.level == "2"
        @initiative.level_code = current_user.province.code
      end
      if @initiative.level == "3"
        @initiative.level_code = current_user.region.code
      end
      if @initiative.level == "4"
        @initiative.level_code = 1
      end
      s = @initiative.save
    else
      flash.now[:alert] = t(:recaptcha_error)
      flash.delete(:recaptcha_error)
      s = false
    end
  
    respond_to do |format|
      if params[:preview_button] || !s
        format.html { render :action => "new" }
        format.xml  { render :xml => @initiative.errors, :status => :unprocessable_entity }
      else
        BillMailer.bill_creation_confirmation(current_user,@initiative).deliver
        format.html { redirect_to(@initiative, :notice => t("initiatives.created")) }
        format.xml  { render :xml => @initiative, :status => :created, :location => @initiative }
      end
    end
  end

  # PUT /initiatives/1
  # PUT /initiatives/1.xml
  def update
    @not_lang = not_current_languages
    if verify_recaptcha()
      flash.delete(:recaptcha_error)
      if (current_user.roles[0].name=="admin") || (@initiative.current_phase == 1)
        if params[:initiative][:photo] && params[:initiative][:photo] == ""
                params[:initiative].delete :photo
        end
        u = @initiative.update_attributes(params[:initiative])
        @initiative.update_attribute(:category, eval("Category.find_by_name_#{I18n.locale}(params[:category])"))

        l=true
        if @initiative.level == "1"
          l = @initiative.update_attribute(:level_code, @initiative.user.commune.postal_code)
        end
        if @initiative.level == "2"
          l = @initiative.update_attribute(:level_code, @initiative.user.province.code)
        end
        if @initiative.level == "3"
          l = @initiative.update_attribute(:level_code, @initiative.user.region.code)
        end
        if @initiative.level == "4"
          l = @initiative.update_attribute(:level_code, 1)
        end
      else
        u = false
      end
    else
      u = false
      flash.now[:alert] = t(:recaptcha_error)
      flash.delete(:recaptcha_error)
    end
    u = u&l

    if  params[:preview_button] || !u
      render :action => "edit"
    else
      redirect_to(@initiative, :notice => t("initiatives.updated"))
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
        format.html { redirect_to(initiatives_url, :notice => t("initiatives.destroyed")) }
        format.xml  { head :ok }
      else
        format.html { redirect_to(@initiative, :notice => t("layout.not_authorized")) }
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
    if (params[:delegated] == "true")
      user_id = current_user.delegate.id
      user_type = "Delegate"
      unless @initiative.rankings.for_ranker(current_user.delegate)[0].nil?
              allowed = @initiative.rankings.for_ranker(current_user.delegate)[0].created_at > (Time.now()-1.day)
      else
              allowed = true
      end
    else
      user_id = current_user.id
      user_type = "User"
      allowed = true
    end
    if allowed
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
    else
      respond_to do |format|
        format.html { redirect_to initiative_url(@initiative,:rankings => @parsed_json) }
        format.js { render(:update) { |page| page.redirect_to initiative_url(@initiative,:rankings => @parsed_json)}
                    flash[:alert] = t("initiatives.not_allowed")
        }
      end
    end
  end

  def aye
     if @initiative.current_phase == 4
       if (params[:delegated] == "true")
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
     if (params[:delegated] == "true")
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

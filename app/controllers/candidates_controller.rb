class CandidatesController < ApplicationController
        filter_resource_access
          before_filter :authenticate_user!, :except => [:show,:index]
          unless ENV['RAILS_ENV']=="development" 
          ssl_required :new, :edit, :create, :update, :destroy
          end
          
  # GET /candidates
  # GET /candidates.xml
  def index
    @candidates = Candidate.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @candidates }
    end
  end

  # GET /candidates/1
  # GET /candidates/1.xml
  def show
    @candidate = Candidate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @candidate }
    end
  end

  # GET /candidates/new
  # GET /candidates/new.xml
  def new
    @candidate = Candidate.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @candidate }
    end
  end

  # GET /candidates/1/edit
  def edit
    @candidate = Candidate.find(params[:id])
  end

  # POST /candidates
  # POST /candidates.xml
  def create
          @candidate = Candidate.new(params[:candidate])
          if params[:candidate][:level] == "1"
                  c = Commune.find_by_postal_code(params[:candidate][:level_code])
                  if c
                          s1 = @candidate.update_attribute(:commune_id, c.id)
                  end
          else 
                  if params[:level] == "2"
                          p = Province.find_by_level_code(params[:candidate][:level_code])
                          if p
                                  s1 = @candidate.update_attribute(:province_id, p.id)
                          end
                  else
                          if params[:level] == "3"
                                  r = Region.find_by_level_code(params[:candidate][:level_code])
                                  if r
                                          s1 = @candidate.update_attribute(:region_id, r.id)
                                  end
                          end
                  end
          end
                
          
          respond_to do |format|
                  if @candidate.save
                          bio_text_en = params[:bio_text_en]
                          bio_text_fr = params[:bio_text_fr]
                          bio_text_nl = params[:bio_text_nl]
                          bio_wiki_en = params[:bio_wiki_en]
                          bio_wiki_fr = params[:bio_wiki_fr]
                          bio_wiki_nl = params[:bio_wiki_nl]
                          h = {:content_en => bio_text_en, :content_fr => bio_text_fr, :content_nl => bio_text_nl, :wiki_en => bio_wiki_en, :wiki_fr => bio_wiki_fr, :wiki_nl => bio_wiki_nl}
                          @bio = @candidate.bios.build(h)
                          if @bio.save
                                  format.html { redirect_to(@candidate, :notice => 'Candidate was successfully created.') }
                                  format.xml  { render :xml => @candidate, :status => :created, :location => @candidate }
                          else
                                  format.html { render :action => "new" }
                                  format.xml  { render :xml => @candidate.errors, :status => :unprocessable_entity }
                          end
                  else
                          format.html { render :action => "new" }
                          format.xml  { render :xml => @candidate.errors, :status => :unprocessable_entity }
                  end
          end
  end

  # PUT /candidates/1
  # PUT /candidates/1.xml
  def update
    @candidate = Candidate.find(params[:id])

    respond_to do |format|
      if @candidate.update_attributes(params[:candidate])
        format.html { redirect_to(@candidate, :notice => 'Candidate was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @candidate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /candidates/1
  # DELETE /candidates/1.xml
  def destroy
    @candidate = Candidate.find(params[:id])
    @candidate.destroy

    respond_to do |format|
      format.html { redirect_to(candidates_url) }
      format.xml  { head :ok }
    end
  end
end

class PoliticiansController < ApplicationController
  filter_resource_access
  before_filter :authenticate_user!, :except => [:show,:index]
  unless ENV['RAILS_ENV']=="development" 
  ssl_required :new, :edit, :create, :update, :destroy
  end
  
  # GET /politicians
  # GET /politicians.xml
  def index
    @politicians = Politician.all(:order => "name")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @politicians }
    end
  end

  # GET /politicians/1
  # GET /politicians/1.xml
  def show
    @politician = Politician.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @politician }
    end
  end

  # GET /politicians/new
  # GET /politicians/new.xml
  def new
    @politician = Politician.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @politician }
    end
  end

  # GET /politicians/1/edit
  def edit
    @politician = Politician.find(params[:id])
  end

  # POST /politicians
  # POST /politicians.xml
  def create
    @politician = Politician.new(params[:politician])
    for p in Party.all
      if params[p.name]
        @politician.update_attribute(:party_id, p.id)
      end
    end

    respond_to do |format|
      if @politician.save
        bio_text_en = params[:bio_text_en]
        bio_text_fr = params[:bio_text_fr]
        bio_text_nl = params[:bio_text_nl]
        bio_wiki_en = params[:bio_wiki_en]
        bio_wiki_fr = params[:bio_wiki_fr]
        bio_wiki_nl = params[:bio_wiki_nl]
        h = {:content_en => bio_text_en, :content_fr => bio_text_fr, :content_nl => bio_text_nl, :wiki_en => bio_wiki_en, :wiki_fr => bio_wiki_fr, :wiki_nl => bio_wiki_nl}
        @bio = @politician.bios.build(h)
        if @bio.save
          format.html { redirect_to(@politician, :notice => 'Politician was successfully created.') }
          format.xml  { render :xml => @politician, :status => :created, :location => @politician }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @politician.errors, :status => :unprocessable_entity }
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @politician.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /politicians/1
  # PUT /politicians/1.xml
  def update
    @politician = Politician.find(params[:id])
    p = Party.find_by_name(params[:party])
    @party = {:party_id => p.id}
    @args = @party.merge!(params[:politician])
      
    @bio = @politician.bios

    respond_to do |format|
      if @politician.update_attributes(@args)
        
        bio_text_en = params[:bio_text_en]
        bio_text_fr = params[:bio_text_fr]
        bio_text_nl = params[:bio_text_nl]
        bio_wiki_en = params[:bio_wiki_en]
        bio_wiki_fr = params[:bio_wiki_fr]
        bio_wiki_nl = params[:bio_wiki_nl]
        h = {:content_en => bio_text_en, :content_fr => bio_text_fr, :content_nl => bio_text_nl, :wiki_en => bio_wiki_en, :wiki_fr => bio_wiki_fr, :wiki_nl => bio_wiki_nl}
        if @bio.blank?
          @bio = @politician.bios.build(h)
          if @bio.save
              format.html { redirect_to(@politician, :notice => 'Politician was successfully updated.') }
              format.xml  { head :ok }
          else
              format.html { render :action => "edit" }
              format.xml  { render :xml => @politician.errors, :status => :unprocessable_entity }
          end
        else
          if @bio[0].update_attributes(h)
              format.html { redirect_to(@politician, :notice => 'Politician was successfully updated.') }
              format.xml  { head :ok }
          else
              format.html { render :action => "edit" }
              format.xml  { render :xml => @politician.errors, :status => :unprocessable_entity }
          end
        end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @politician.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /politicians/1
  # DELETE /politicians/1.xml
  def destroy
    @politician = Politician.find(params[:id])
    @politician.destroy

    respond_to do |format|
      format.html { redirect_to(politicians_url) }
      format.xml  { head :ok }
    end
  end
  
end

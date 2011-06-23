class PartiesController < ApplicationController
  filter_resource_access
  before_filter :authenticate_user!, :except => [:show,:index]
  unless ENV['RAILS_ENV']=="development" 
  ssl_required :new, :edit, :create, :update, :destroy
  end
  
  # GET /parties
  # GET /parties.xml
  def index
    @parties = Party.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @parties }
    end
  end

  # GET /parties/1
  # GET /parties/1.xml
  def show
    @party = Party.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @party }
    end
  end

  # GET /parties/new
  # GET /parties/new.xml
  def new
    @party = Party.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @party }
    end
  end

  # GET /parties/1/edit
  def edit
    @party = Party.find(params[:id])
  end

  # POST /parties
  # POST /parties.xml
  def create
    @party = Party.new(params[:party])
    
    respond_to do |format|
      if @party.save
         bio_text_en = params[:bio_text_en]
          bio_text_fr = params[:bio_text_fr]
          bio_text_nl = params[:bio_text_nl]
          bio_wiki_en = params[:bio_wiki_en]
          bio_wiki_fr = params[:bio_wiki_fr]
          bio_wiki_nl = params[:bio_wiki_nl]
          h = {:content_en => bio_text_en, :content_fr => bio_text_fr, :content_nl => bio_text_nl, :wiki_en => bio_wiki_en, :wiki_fr => bio_wiki_fr, :wiki_nl => bio_wiki_nl}
          @bio = @party.bios.build(h)
          if @bio.save
            format.html { redirect_to(@party, :notice => 'Party was successfully created.') }
            format.xml  { render :xml => @party, :status => :created, :location => @party }
          else
            format.html { render :action => "new" }
            format.xml  { render :xml => @party.errors, :status => :unprocessable_entity }
          end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @party.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /parties/1
  # PUT /parties/1.xml
  def update
    @party = Party.find(params[:id])
    @bio = @party.bios

    respond_to do |format|
      if @party.update_attributes(params[:party])
        bio_text_en = params[:bio_text_en]
        bio_text_fr = params[:bio_text_fr]
        bio_text_nl = params[:bio_text_nl]
        bio_wiki_en = params[:bio_wiki_en]
        bio_wiki_fr = params[:bio_wiki_fr]
        bio_wiki_nl = params[:bio_wiki_nl]
        h = {:content_en => bio_text_en, :content_fr => bio_text_fr, :content_nl => bio_text_nl, :wiki_en => bio_wiki_en, :wiki_fr => bio_wiki_fr, :wiki_nl => bio_wiki_nl}
        if @bio.blank?
          @bio = @party.bios.build(h)
          if @bio.save
              format.html { redirect_to(@party, :notice => 'Party was successfully updated.') }
              format.xml  { head :ok }
          else
              format.html { render :action => "edit" }
              format.xml  { render :xml => @party.errors, :status => :unprocessable_entity }
          end
        else
          if @bio[0].update_attributes(h)
            format.html { redirect_to(@party, :notice => 'Party was successfully updated.') }
            format.xml  { head :ok }
          else
            format.html { render :action => "edit" }
            format.xml  { render :xml => @party.errors, :status => :unprocessable_entity }
          end
        end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @party.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /parties/1
  # DELETE /parties/1.xml
  def destroy
    @party = Party.find(params[:id])
    @party.destroy

    respond_to do |format|
      format.html { redirect_to(parties_url) }
      format.xml  { head :ok }
    end
  end
end

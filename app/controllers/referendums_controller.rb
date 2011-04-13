class ReferendumsController < ApplicationController
  filter_resource_access
  
  # GET /referendums
  # GET /referendums.xml
  def index
    @referendums = Referendum.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @referendums }
    end
  end

  # GET /referendums/1
  # GET /referendums/1.xml
  def show
    @referendum = Referendum.find(params[:id])

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
  end

  # POST /referendums
  # POST /referendums.xml
  def create
    @referendum = Referendum.new(params[:referendum])

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
    @referendum = Referendum.find(params[:id])

    respond_to do |format|
      if @referendum.update_attributes(params[:referendum])
        format.html { redirect_to(@referendum, :notice => 'Referendum was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @referendum.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /referendums/1
  # DELETE /referendums/1.xml
  def destroy
    @referendum = Referendum.find(params[:id])
    @referendum.destroy

    respond_to do |format|
      format.html { redirect_to(referendums_url) }
      format.xml  { head :ok }
    end
  end
end

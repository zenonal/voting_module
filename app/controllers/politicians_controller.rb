class PoliticiansController < ApplicationController
  # GET /politicians
  # GET /politicians.xml
  def index
    @politicians = Politician.all

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

    respond_to do |format|
      if @politician.save
        format.html { redirect_to(@politician, :notice => 'Politician was successfully created.') }
        format.xml  { render :xml => @politician, :status => :created, :location => @politician }
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

    respond_to do |format|
      if @politician.update_attributes(params[:politician])
        format.html { redirect_to(@politician, :notice => 'Politician was successfully updated.') }
        format.xml  { head :ok }
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

class CommunitiesController < ApplicationController
        filter_resource_access
        before_filter :authenticate_user!

        def index
                @communities = Community.all

                respond_to do |format|
                        format.html # index.html.erb
                        format.xml  { render :xml => @communities }
                end
        end

        def new
                @community = Community.new

                respond_to do |format|
                        format.html # new.html.erb
                        format.xml  { render :xml => @community }
                end
        end

        def edit
                @community = Community.find(params[:id])
        end

        def create
                @community = Community.new(params[:community])

                respond_to do |format|
                        if @community.save
                                format.html { redirect_to(@community, :notice => "New Community created") }
                                format.xml  { render :xml => @community, :status => :created, :location => @community }
                        else
                                format.html { render :action => "new" }
                                format.xml  { render :xml => @community.errors, :status => :unprocessable_entity }
                        end
                end
        end

        def update
                @community = Community.find(params[:id])

                respond_to do |format|
                        if @community.update_attributes(params[:community])
                                format.html { redirect_to(@community, :notice => "Community updated") }
                                format.xml  { head :ok }
                        else
                                format.html { render :action => "edit" }
                                format.xml  { render :xml => @community.errors, :status => :unprocessable_entity }
                        end
                end

        end

        def destroy
                @community = Community.find(params[:id])
                @community.destroy

                respond_to do |format|
                        format.html { redirect_to(communities_url) }
                        format.xml  { head :ok }
                end
        end
end

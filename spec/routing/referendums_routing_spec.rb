require "spec_helper"

describe ReferendumsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/referendums" }.should route_to(:controller => "referendums", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/referendums/new" }.should route_to(:controller => "referendums", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/referendums/1" }.should route_to(:controller => "referendums", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/referendums/1/edit" }.should route_to(:controller => "referendums", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/referendums" }.should route_to(:controller => "referendums", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/referendums/1" }.should route_to(:controller => "referendums", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/referendums/1" }.should route_to(:controller => "referendums", :action => "destroy", :id => "1")
    end

  end
end

require "spec_helper"

describe CandidatesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/candidates" }.should route_to(:controller => "candidates", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/candidates/new" }.should route_to(:controller => "candidates", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/candidates/1" }.should route_to(:controller => "candidates", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/candidates/1/edit" }.should route_to(:controller => "candidates", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/candidates" }.should route_to(:controller => "candidates", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/candidates/1" }.should route_to(:controller => "candidates", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/candidates/1" }.should route_to(:controller => "candidates", :action => "destroy", :id => "1")
    end

  end
end

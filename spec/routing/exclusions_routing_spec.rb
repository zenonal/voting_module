require "spec_helper"

describe ExclusionsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/exclusions" }.should route_to(:controller => "exclusions", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/exclusions/new" }.should route_to(:controller => "exclusions", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/exclusions/1" }.should route_to(:controller => "exclusions", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/exclusions/1/edit" }.should route_to(:controller => "exclusions", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/exclusions" }.should route_to(:controller => "exclusions", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/exclusions/1" }.should route_to(:controller => "exclusions", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/exclusions/1" }.should route_to(:controller => "exclusions", :action => "destroy", :id => "1")
    end

  end
end

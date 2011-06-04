require "spec_helper"

describe DelegatesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/delegates" }.should route_to(:controller => "delegates", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/delegates/new" }.should route_to(:controller => "delegates", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/delegates/1" }.should route_to(:controller => "delegates", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/delegates/1/edit" }.should route_to(:controller => "delegates", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/delegates" }.should route_to(:controller => "delegates", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/delegates/1" }.should route_to(:controller => "delegates", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/delegates/1" }.should route_to(:controller => "delegates", :action => "destroy", :id => "1")
    end

  end
end

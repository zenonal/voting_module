require "spec_helper"

describe DelegationsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/delegations" }.should route_to(:controller => "delegations", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/delegations/new" }.should route_to(:controller => "delegations", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/delegations/1" }.should route_to(:controller => "delegations", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/delegations/1/edit" }.should route_to(:controller => "delegations", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/delegations" }.should route_to(:controller => "delegations", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/delegations/1" }.should route_to(:controller => "delegations", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/delegations/1" }.should route_to(:controller => "delegations", :action => "destroy", :id => "1")
    end

  end
end

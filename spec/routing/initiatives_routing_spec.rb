require "spec_helper"

describe InitiativesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/initiatives" }.should route_to(:controller => "initiatives", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/initiatives/new" }.should route_to(:controller => "initiatives", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/initiatives/1" }.should route_to(:controller => "initiatives", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/initiatives/1/edit" }.should route_to(:controller => "initiatives", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/initiatives" }.should route_to(:controller => "initiatives", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/initiatives/1" }.should route_to(:controller => "initiatives", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/initiatives/1" }.should route_to(:controller => "initiatives", :action => "destroy", :id => "1")
    end

  end
end

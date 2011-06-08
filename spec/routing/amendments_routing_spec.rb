require "spec_helper"

describe AmendmentsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/amendments" }.should route_to(:controller => "amendments", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/amendments/new" }.should route_to(:controller => "amendments", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/amendments/1" }.should route_to(:controller => "amendments", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/amendments/1/edit" }.should route_to(:controller => "amendments", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/amendments" }.should route_to(:controller => "amendments", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/amendments/1" }.should route_to(:controller => "amendments", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/amendments/1" }.should route_to(:controller => "amendments", :action => "destroy", :id => "1")
    end

  end
end

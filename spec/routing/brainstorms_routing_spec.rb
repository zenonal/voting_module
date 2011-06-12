require "spec_helper"

describe BrainstormsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/brainstorms" }.should route_to(:controller => "brainstorms", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/brainstorms/new" }.should route_to(:controller => "brainstorms", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/brainstorms/1" }.should route_to(:controller => "brainstorms", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/brainstorms/1/edit" }.should route_to(:controller => "brainstorms", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/brainstorms" }.should route_to(:controller => "brainstorms", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/brainstorms/1" }.should route_to(:controller => "brainstorms", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/brainstorms/1" }.should route_to(:controller => "brainstorms", :action => "destroy", :id => "1")
    end

  end
end

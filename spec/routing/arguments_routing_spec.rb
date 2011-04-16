require "spec_helper"

describe ArgumentsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/arguments" }.should route_to(:controller => "arguments", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/arguments/new" }.should route_to(:controller => "arguments", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/arguments/1" }.should route_to(:controller => "arguments", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/arguments/1/edit" }.should route_to(:controller => "arguments", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/arguments" }.should route_to(:controller => "arguments", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/arguments/1" }.should route_to(:controller => "arguments", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/arguments/1" }.should route_to(:controller => "arguments", :action => "destroy", :id => "1")
    end

  end
end

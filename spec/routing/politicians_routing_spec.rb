require "spec_helper"

describe PoliticiansController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/politicians" }.should route_to(:controller => "politicians", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/politicians/new" }.should route_to(:controller => "politicians", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/politicians/1" }.should route_to(:controller => "politicians", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/politicians/1/edit" }.should route_to(:controller => "politicians", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/politicians" }.should route_to(:controller => "politicians", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/politicians/1" }.should route_to(:controller => "politicians", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/politicians/1" }.should route_to(:controller => "politicians", :action => "destroy", :id => "1")
    end

  end
end

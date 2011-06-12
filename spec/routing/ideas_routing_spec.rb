require "spec_helper"

describe IdeasController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/ideas" }.should route_to(:controller => "ideas", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/ideas/new" }.should route_to(:controller => "ideas", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/ideas/1" }.should route_to(:controller => "ideas", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/ideas/1/edit" }.should route_to(:controller => "ideas", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/ideas" }.should route_to(:controller => "ideas", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/ideas/1" }.should route_to(:controller => "ideas", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/ideas/1" }.should route_to(:controller => "ideas", :action => "destroy", :id => "1")
    end

  end
end

require "spec_helper"

describe PartiesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/parties" }.should route_to(:controller => "parties", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/parties/new" }.should route_to(:controller => "parties", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/parties/1" }.should route_to(:controller => "parties", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/parties/1/edit" }.should route_to(:controller => "parties", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/parties" }.should route_to(:controller => "parties", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/parties/1" }.should route_to(:controller => "parties", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/parties/1" }.should route_to(:controller => "parties", :action => "destroy", :id => "1")
    end

  end
end

require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe PoliticiansController do

  def mock_politician(stubs={})
    @mock_politician ||= mock_model(Politician, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all politicians as @politicians" do
      Politician.stub(:all) { [mock_politician] }
      get :index
      assigns(:politicians).should eq([mock_politician])
    end
  end

  describe "GET show" do
    it "assigns the requested politician as @politician" do
      Politician.stub(:find).with("37") { mock_politician }
      get :show, :id => "37"
      assigns(:politician).should be(mock_politician)
    end
  end

  describe "GET new" do
    it "assigns a new politician as @politician" do
      Politician.stub(:new) { mock_politician }
      get :new
      assigns(:politician).should be(mock_politician)
    end
  end

  describe "GET edit" do
    it "assigns the requested politician as @politician" do
      Politician.stub(:find).with("37") { mock_politician }
      get :edit, :id => "37"
      assigns(:politician).should be(mock_politician)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created politician as @politician" do
        Politician.stub(:new).with({'these' => 'params'}) { mock_politician(:save => true) }
        post :create, :politician => {'these' => 'params'}
        assigns(:politician).should be(mock_politician)
      end

      it "redirects to the created politician" do
        Politician.stub(:new) { mock_politician(:save => true) }
        post :create, :politician => {}
        response.should redirect_to(politician_url(mock_politician))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved politician as @politician" do
        Politician.stub(:new).with({'these' => 'params'}) { mock_politician(:save => false) }
        post :create, :politician => {'these' => 'params'}
        assigns(:politician).should be(mock_politician)
      end

      it "re-renders the 'new' template" do
        Politician.stub(:new) { mock_politician(:save => false) }
        post :create, :politician => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested politician" do
        Politician.stub(:find).with("37") { mock_politician }
        mock_politician.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :politician => {'these' => 'params'}
      end

      it "assigns the requested politician as @politician" do
        Politician.stub(:find) { mock_politician(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:politician).should be(mock_politician)
      end

      it "redirects to the politician" do
        Politician.stub(:find) { mock_politician(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(politician_url(mock_politician))
      end
    end

    describe "with invalid params" do
      it "assigns the politician as @politician" do
        Politician.stub(:find) { mock_politician(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:politician).should be(mock_politician)
      end

      it "re-renders the 'edit' template" do
        Politician.stub(:find) { mock_politician(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested politician" do
      Politician.stub(:find).with("37") { mock_politician }
      mock_politician.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the politicians list" do
      Politician.stub(:find) { mock_politician }
      delete :destroy, :id => "1"
      response.should redirect_to(politicians_url)
    end
  end

end
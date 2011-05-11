require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe ExclusionsController do

  def mock_exclusion(stubs={})
    @mock_exclusion ||= mock_model(Exclusion, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all exclusions as @exclusions" do
      Exclusion.stub(:all) { [mock_exclusion] }
      get :index
      assigns(:exclusions).should eq([mock_exclusion])
    end
  end

  describe "GET show" do
    it "assigns the requested exclusion as @exclusion" do
      Exclusion.stub(:find).with("37") { mock_exclusion }
      get :show, :id => "37"
      assigns(:exclusion).should be(mock_exclusion)
    end
  end

  describe "GET new" do
    it "assigns a new exclusion as @exclusion" do
      Exclusion.stub(:new) { mock_exclusion }
      get :new
      assigns(:exclusion).should be(mock_exclusion)
    end
  end

  describe "GET edit" do
    it "assigns the requested exclusion as @exclusion" do
      Exclusion.stub(:find).with("37") { mock_exclusion }
      get :edit, :id => "37"
      assigns(:exclusion).should be(mock_exclusion)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created exclusion as @exclusion" do
        Exclusion.stub(:new).with({'these' => 'params'}) { mock_exclusion(:save => true) }
        post :create, :exclusion => {'these' => 'params'}
        assigns(:exclusion).should be(mock_exclusion)
      end

      it "redirects to the created exclusion" do
        Exclusion.stub(:new) { mock_exclusion(:save => true) }
        post :create, :exclusion => {}
        response.should redirect_to(exclusion_url(mock_exclusion))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved exclusion as @exclusion" do
        Exclusion.stub(:new).with({'these' => 'params'}) { mock_exclusion(:save => false) }
        post :create, :exclusion => {'these' => 'params'}
        assigns(:exclusion).should be(mock_exclusion)
      end

      it "re-renders the 'new' template" do
        Exclusion.stub(:new) { mock_exclusion(:save => false) }
        post :create, :exclusion => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested exclusion" do
        Exclusion.stub(:find).with("37") { mock_exclusion }
        mock_exclusion.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :exclusion => {'these' => 'params'}
      end

      it "assigns the requested exclusion as @exclusion" do
        Exclusion.stub(:find) { mock_exclusion(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:exclusion).should be(mock_exclusion)
      end

      it "redirects to the exclusion" do
        Exclusion.stub(:find) { mock_exclusion(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(exclusion_url(mock_exclusion))
      end
    end

    describe "with invalid params" do
      it "assigns the exclusion as @exclusion" do
        Exclusion.stub(:find) { mock_exclusion(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:exclusion).should be(mock_exclusion)
      end

      it "re-renders the 'edit' template" do
        Exclusion.stub(:find) { mock_exclusion(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested exclusion" do
      Exclusion.stub(:find).with("37") { mock_exclusion }
      mock_exclusion.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the exclusions list" do
      Exclusion.stub(:find) { mock_exclusion }
      delete :destroy, :id => "1"
      response.should redirect_to(exclusions_url)
    end
  end

end

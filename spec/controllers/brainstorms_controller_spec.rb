require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe BrainstormsController do

  def mock_brainstorm(stubs={})
    @mock_brainstorm ||= mock_model(Brainstorm, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all brainstorms as @brainstorms" do
      Brainstorm.stub(:all) { [mock_brainstorm] }
      get :index
      assigns(:brainstorms).should eq([mock_brainstorm])
    end
  end

  describe "GET show" do
    it "assigns the requested brainstorm as @brainstorm" do
      Brainstorm.stub(:find).with("37") { mock_brainstorm }
      get :show, :id => "37"
      assigns(:brainstorm).should be(mock_brainstorm)
    end
  end

  describe "GET new" do
    it "assigns a new brainstorm as @brainstorm" do
      Brainstorm.stub(:new) { mock_brainstorm }
      get :new
      assigns(:brainstorm).should be(mock_brainstorm)
    end
  end

  describe "GET edit" do
    it "assigns the requested brainstorm as @brainstorm" do
      Brainstorm.stub(:find).with("37") { mock_brainstorm }
      get :edit, :id => "37"
      assigns(:brainstorm).should be(mock_brainstorm)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created brainstorm as @brainstorm" do
        Brainstorm.stub(:new).with({'these' => 'params'}) { mock_brainstorm(:save => true) }
        post :create, :brainstorm => {'these' => 'params'}
        assigns(:brainstorm).should be(mock_brainstorm)
      end

      it "redirects to the created brainstorm" do
        Brainstorm.stub(:new) { mock_brainstorm(:save => true) }
        post :create, :brainstorm => {}
        response.should redirect_to(brainstorm_url(mock_brainstorm))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved brainstorm as @brainstorm" do
        Brainstorm.stub(:new).with({'these' => 'params'}) { mock_brainstorm(:save => false) }
        post :create, :brainstorm => {'these' => 'params'}
        assigns(:brainstorm).should be(mock_brainstorm)
      end

      it "re-renders the 'new' template" do
        Brainstorm.stub(:new) { mock_brainstorm(:save => false) }
        post :create, :brainstorm => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested brainstorm" do
        Brainstorm.stub(:find).with("37") { mock_brainstorm }
        mock_brainstorm.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :brainstorm => {'these' => 'params'}
      end

      it "assigns the requested brainstorm as @brainstorm" do
        Brainstorm.stub(:find) { mock_brainstorm(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:brainstorm).should be(mock_brainstorm)
      end

      it "redirects to the brainstorm" do
        Brainstorm.stub(:find) { mock_brainstorm(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(brainstorm_url(mock_brainstorm))
      end
    end

    describe "with invalid params" do
      it "assigns the brainstorm as @brainstorm" do
        Brainstorm.stub(:find) { mock_brainstorm(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:brainstorm).should be(mock_brainstorm)
      end

      it "re-renders the 'edit' template" do
        Brainstorm.stub(:find) { mock_brainstorm(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested brainstorm" do
      Brainstorm.stub(:find).with("37") { mock_brainstorm }
      mock_brainstorm.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the brainstorms list" do
      Brainstorm.stub(:find) { mock_brainstorm }
      delete :destroy, :id => "1"
      response.should redirect_to(brainstorms_url)
    end
  end

end
require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe AmendmentsController do

  def mock_amendment(stubs={})
    @mock_amendment ||= mock_model(Amendment, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all amendments as @amendments" do
      Amendment.stub(:all) { [mock_amendment] }
      get :index
      assigns(:amendments).should eq([mock_amendment])
    end
  end

  describe "GET show" do
    it "assigns the requested amendment as @amendment" do
      Amendment.stub(:find).with("37") { mock_amendment }
      get :show, :id => "37"
      assigns(:amendment).should be(mock_amendment)
    end
  end

  describe "GET new" do
    it "assigns a new amendment as @amendment" do
      Amendment.stub(:new) { mock_amendment }
      get :new
      assigns(:amendment).should be(mock_amendment)
    end
  end

  describe "GET edit" do
    it "assigns the requested amendment as @amendment" do
      Amendment.stub(:find).with("37") { mock_amendment }
      get :edit, :id => "37"
      assigns(:amendment).should be(mock_amendment)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created amendment as @amendment" do
        Amendment.stub(:new).with({'these' => 'params'}) { mock_amendment(:save => true) }
        post :create, :amendment => {'these' => 'params'}
        assigns(:amendment).should be(mock_amendment)
      end

      it "redirects to the created amendment" do
        Amendment.stub(:new) { mock_amendment(:save => true) }
        post :create, :amendment => {}
        response.should redirect_to(amendment_url(mock_amendment))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved amendment as @amendment" do
        Amendment.stub(:new).with({'these' => 'params'}) { mock_amendment(:save => false) }
        post :create, :amendment => {'these' => 'params'}
        assigns(:amendment).should be(mock_amendment)
      end

      it "re-renders the 'new' template" do
        Amendment.stub(:new) { mock_amendment(:save => false) }
        post :create, :amendment => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested amendment" do
        Amendment.stub(:find).with("37") { mock_amendment }
        mock_amendment.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :amendment => {'these' => 'params'}
      end

      it "assigns the requested amendment as @amendment" do
        Amendment.stub(:find) { mock_amendment(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:amendment).should be(mock_amendment)
      end

      it "redirects to the amendment" do
        Amendment.stub(:find) { mock_amendment(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(amendment_url(mock_amendment))
      end
    end

    describe "with invalid params" do
      it "assigns the amendment as @amendment" do
        Amendment.stub(:find) { mock_amendment(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:amendment).should be(mock_amendment)
      end

      it "re-renders the 'edit' template" do
        Amendment.stub(:find) { mock_amendment(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested amendment" do
      Amendment.stub(:find).with("37") { mock_amendment }
      mock_amendment.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the amendments list" do
      Amendment.stub(:find) { mock_amendment }
      delete :destroy, :id => "1"
      response.should redirect_to(amendments_url)
    end
  end

end

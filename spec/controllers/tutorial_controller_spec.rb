require 'spec_helper'

describe TutorialController do

  describe "GET 'video'" do
    it "should be successful" do
      get 'video'
      response.should be_success
    end
  end

  describe "GET 'manual'" do
    it "should be successful" do
      get 'manual'
      response.should be_success
    end
  end

end

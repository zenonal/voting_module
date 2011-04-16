require 'spec_helper'

describe LanguageController do

  describe "GET 'fra'" do
    it "should be successful" do
      get 'fra'
      response.should be_success
    end
  end

  describe "GET 'ndl'" do
    it "should be successful" do
      get 'ndl'
      response.should be_success
    end
  end

  describe "GET 'eng'" do
    it "should be successful" do
      get 'eng'
      response.should be_success
    end
  end

end

require 'spec_helper'

describe InfoController do

  describe "GET 'homepage'" do
    it "should be successful" do
      get 'homepage'
      response.should be_success
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
  end

end

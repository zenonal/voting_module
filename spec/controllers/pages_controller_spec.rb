require 'spec_helper'

describe PagesController do

  describe "GET 'Homepage'" do
    it "should be successful" do
      get 'Homepage'
      response.should be_success
    end
  end

end

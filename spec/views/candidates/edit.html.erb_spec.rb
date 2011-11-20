require 'spec_helper'

describe "candidates/edit.html.erb" do
  before(:each) do
    @candidate = assign(:candidate, stub_model(Candidate,
      :name => "MyString",
      :photo_file_name => "MyString",
      :photo_content_type => "MyString",
      :photo_file_size => 1,
      :level => "MyString",
      :level_code => 1
    ))
  end

  it "renders the edit candidate form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => candidates_path(@candidate), :method => "post" do
      assert_select "input#candidate_name", :name => "candidate[name]"
      assert_select "input#candidate_photo_file_name", :name => "candidate[photo_file_name]"
      assert_select "input#candidate_photo_content_type", :name => "candidate[photo_content_type]"
      assert_select "input#candidate_photo_file_size", :name => "candidate[photo_file_size]"
      assert_select "input#candidate_level", :name => "candidate[level]"
      assert_select "input#candidate_level_code", :name => "candidate[level_code]"
    end
  end
end

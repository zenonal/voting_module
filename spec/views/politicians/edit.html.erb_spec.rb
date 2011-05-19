require 'spec_helper'

describe "politicians/edit.html.erb" do
  before(:each) do
    @politician = assign(:politician, stub_model(Politician,
      :name => "MyString",
      :photo_file_name => "MyString",
      :photo_content_type => "MyString",
      :photo_file_size => 1
    ))
  end

  it "renders the edit politician form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => politicians_path(@politician), :method => "post" do
      assert_select "input#politician_name", :name => "politician[name]"
      assert_select "input#politician_photo_file_name", :name => "politician[photo_file_name]"
      assert_select "input#politician_photo_content_type", :name => "politician[photo_content_type]"
      assert_select "input#politician_photo_file_size", :name => "politician[photo_file_size]"
    end
  end
end

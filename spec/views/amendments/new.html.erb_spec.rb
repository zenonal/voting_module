require 'spec_helper'

describe "amendments/new.html.erb" do
  before(:each) do
    assign(:amendment, stub_model(Amendment,
      :name_en => "MyString",
      :content_en => "MyText",
      :name_fr => "MyString",
      :content_fr => "MyText",
      :name_nl => "MyString",
      :content_nl => "MyText",
      :user_id => 1,
      :photo_file_name => "MyString",
      :photo_content_type => "MyString",
      :photo_file_size => 1,
      :validations_count => 1
    ).as_new_record)
  end

  it "renders new amendment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => amendments_path, :method => "post" do
      assert_select "input#amendment_name_en", :name => "amendment[name_en]"
      assert_select "textarea#amendment_content_en", :name => "amendment[content_en]"
      assert_select "input#amendment_name_fr", :name => "amendment[name_fr]"
      assert_select "textarea#amendment_content_fr", :name => "amendment[content_fr]"
      assert_select "input#amendment_name_nl", :name => "amendment[name_nl]"
      assert_select "textarea#amendment_content_nl", :name => "amendment[content_nl]"
      assert_select "input#amendment_user_id", :name => "amendment[user_id]"
      assert_select "input#amendment_photo_file_name", :name => "amendment[photo_file_name]"
      assert_select "input#amendment_photo_content_type", :name => "amendment[photo_content_type]"
      assert_select "input#amendment_photo_file_size", :name => "amendment[photo_file_size]"
      assert_select "input#amendment_validations_count", :name => "amendment[validations_count]"
    end
  end
end

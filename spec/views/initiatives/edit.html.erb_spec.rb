require 'spec_helper'

describe "initiatives/edit.html.erb" do
  before(:each) do
    @initiative = assign(:initiative, stub_model(Initiative,
      :name_en => "MyString",
      :content_en => "MyText",
      :name_fr => "MyString",
      :content_fr => "MyText",
      :name_nl => "MyString",
      :content_nl => "MyText",
      :category_id => 1,
      :user_id => 1,
      :photo_file_name => "MyString",
      :photo_content_type => "MyString",
      :photo_file_size => 1,
      :validation_id => 1
    ))
  end

  it "renders the edit initiative form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => initiatives_path(@initiative), :method => "post" do
      assert_select "input#initiative_name_en", :name => "initiative[name_en]"
      assert_select "textarea#initiative_content_en", :name => "initiative[content_en]"
      assert_select "input#initiative_name_fr", :name => "initiative[name_fr]"
      assert_select "textarea#initiative_content_fr", :name => "initiative[content_fr]"
      assert_select "input#initiative_name_nl", :name => "initiative[name_nl]"
      assert_select "textarea#initiative_content_nl", :name => "initiative[content_nl]"
      assert_select "input#initiative_category_id", :name => "initiative[category_id]"
      assert_select "input#initiative_user_id", :name => "initiative[user_id]"
      assert_select "input#initiative_photo_file_name", :name => "initiative[photo_file_name]"
      assert_select "input#initiative_photo_content_type", :name => "initiative[photo_content_type]"
      assert_select "input#initiative_photo_file_size", :name => "initiative[photo_file_size]"
      assert_select "input#initiative_validation_id", :name => "initiative[validation_id]"
    end
  end
end

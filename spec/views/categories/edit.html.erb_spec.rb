require 'spec_helper'

describe "categories/edit.html.erb" do
  before(:each) do
    @category = assign(:category, stub_model(Category,
      :name_fr => "MyString",
      :name_en => "MyString",
      :name_nl => "MyString",
      :photo_file_name => "MyString",
      :photo_content_type => "MyString",
      :photo_file_size => 1
    ))
  end

  it "renders the edit category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => categories_path(@category), :method => "post" do
      assert_select "input#category_name_fr", :name => "category[name_fr]"
      assert_select "input#category_name_en", :name => "category[name_en]"
      assert_select "input#category_name_nl", :name => "category[name_nl]"
      assert_select "input#category_photo_file_name", :name => "category[photo_file_name]"
      assert_select "input#category_photo_content_type", :name => "category[photo_content_type]"
      assert_select "input#category_photo_file_size", :name => "category[photo_file_size]"
    end
  end
end

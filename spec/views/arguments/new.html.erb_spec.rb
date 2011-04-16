require 'spec_helper'

describe "arguments/new.html.erb" do
  before(:each) do
    assign(:argument, stub_model(Argument,
      :content => "MyText",
      :user_id => 1,
      :pro => false,
      :argumentable_id => 1,
      :argumentable_type => "MyString"
    ).as_new_record)
  end

  it "renders new argument form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => arguments_path, :method => "post" do
      assert_select "textarea#argument_content", :name => "argument[content]"
      assert_select "input#argument_user_id", :name => "argument[user_id]"
      assert_select "input#argument_pro", :name => "argument[pro]"
      assert_select "input#argument_argumentable_id", :name => "argument[argumentable_id]"
      assert_select "input#argument_argumentable_type", :name => "argument[argumentable_type]"
    end
  end
end

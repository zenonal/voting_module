require 'spec_helper'

describe "brainstorms/new.html.erb" do
  before(:each) do
    assign(:brainstorm, stub_model(Brainstorm,
      :brainstormable_type => "MyString",
      :brainstormable_id => 1
    ).as_new_record)
  end

  it "renders new brainstorm form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => brainstorms_path, :method => "post" do
      assert_select "input#brainstorm_brainstormable_type", :name => "brainstorm[brainstormable_type]"
      assert_select "input#brainstorm_brainstormable_id", :name => "brainstorm[brainstormable_id]"
    end
  end
end

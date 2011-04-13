require 'spec_helper'

describe "referendums/new.html.erb" do
  before(:each) do
    assign(:referendum, stub_model(Referendum,
      :name => "MyString",
      :content => "MyText"
    ).as_new_record)
  end

  it "renders new referendum form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => referendums_path, :method => "post" do
      assert_select "input#referendum_name", :name => "referendum[name]"
      assert_select "textarea#referendum_content", :name => "referendum[content]"
    end
  end
end

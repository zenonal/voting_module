require 'spec_helper'

describe "referendums/edit.html.erb" do
  before(:each) do
    @referendum = assign(:referendum, stub_model(Referendum,
      :name => "MyString",
      :content => "MyText"
    ))
  end

  it "renders the edit referendum form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => referendums_path(@referendum), :method => "post" do
      assert_select "input#referendum_name", :name => "referendum[name]"
      assert_select "textarea#referendum_content", :name => "referendum[content]"
    end
  end
end

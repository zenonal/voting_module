require 'spec_helper'

describe "arguments/index.html.erb" do
  before(:each) do
    assign(:arguments, [
      stub_model(Argument,
        :content => "MyText",
        :user_id => 1,
        :pro => false,
        :argumentable_id => 1,
        :argumentable_type => "Argumentable Type"
      ),
      stub_model(Argument,
        :content => "MyText",
        :user_id => 1,
        :pro => false,
        :argumentable_id => 1,
        :argumentable_type => "Argumentable Type"
      )
    ])
  end

  it "renders a list of arguments" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Argumentable Type".to_s, :count => 2
  end
end

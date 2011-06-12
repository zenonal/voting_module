require 'spec_helper'

describe "brainstorms/index.html.erb" do
  before(:each) do
    assign(:brainstorms, [
      stub_model(Brainstorm,
        :brainstormable_type => "Brainstormable Type",
        :brainstormable_id => 1
      ),
      stub_model(Brainstorm,
        :brainstormable_type => "Brainstormable Type",
        :brainstormable_id => 1
      )
    ])
  end

  it "renders a list of brainstorms" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Brainstormable Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end

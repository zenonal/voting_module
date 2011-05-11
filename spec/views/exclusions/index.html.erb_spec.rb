require 'spec_helper'

describe "exclusions/index.html.erb" do
  before(:each) do
    assign(:exclusions, [
      stub_model(Exclusion,
        :user_id => 1,
        :excludable_id => 1,
        :excludable_type => "Excludable Type"
      ),
      stub_model(Exclusion,
        :user_id => 1,
        :excludable_id => 1,
        :excludable_type => "Excludable Type"
      )
    ])
  end

  it "renders a list of exclusions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Excludable Type".to_s, :count => 2
  end
end

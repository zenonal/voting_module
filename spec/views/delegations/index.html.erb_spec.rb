require 'spec_helper'

describe "delegations/index.html.erb" do
  before(:each) do
    assign(:delegations, [
      stub_model(Delegation,
        :user_id => 1,
        :delegate_id => 1
      ),
      stub_model(Delegation,
        :user_id => 1,
        :delegate_id => 1
      )
    ])
  end

  it "renders a list of delegations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end

require 'spec_helper'

describe "delegations/show.html.erb" do
  before(:each) do
    @delegation = assign(:delegation, stub_model(Delegation,
      :user_id => 1,
      :delegate_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end

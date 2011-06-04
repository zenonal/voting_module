require 'spec_helper'

describe "delegations/edit.html.erb" do
  before(:each) do
    @delegation = assign(:delegation, stub_model(Delegation,
      :user_id => 1,
      :delegate_id => 1
    ))
  end

  it "renders the edit delegation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => delegations_path(@delegation), :method => "post" do
      assert_select "input#delegation_user_id", :name => "delegation[user_id]"
      assert_select "input#delegation_delegate_id", :name => "delegation[delegate_id]"
    end
  end
end

require 'spec_helper'

describe "delegates/edit.html.erb" do
  before(:each) do
    @delegate = assign(:delegate, stub_model(Delegate,
      :user_id => 1
    ))
  end

  it "renders the edit delegate form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => delegates_path(@delegate), :method => "post" do
      assert_select "input#delegate_user_id", :name => "delegate[user_id]"
    end
  end
end

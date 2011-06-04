require 'spec_helper'

describe "delegates/new.html.erb" do
  before(:each) do
    assign(:delegate, stub_model(Delegate,
      :user_id => 1
    ).as_new_record)
  end

  it "renders new delegate form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => delegates_path, :method => "post" do
      assert_select "input#delegate_user_id", :name => "delegate[user_id]"
    end
  end
end

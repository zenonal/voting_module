require 'spec_helper'

describe "exclusions/edit.html.erb" do
  before(:each) do
    @exclusion = assign(:exclusion, stub_model(Exclusion,
      :user_id => 1,
      :excludable_id => 1,
      :excludable_type => "MyString"
    ))
  end

  it "renders the edit exclusion form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => exclusions_path(@exclusion), :method => "post" do
      assert_select "input#exclusion_user_id", :name => "exclusion[user_id]"
      assert_select "input#exclusion_excludable_id", :name => "exclusion[excludable_id]"
      assert_select "input#exclusion_excludable_type", :name => "exclusion[excludable_type]"
    end
  end
end

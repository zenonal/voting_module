require 'spec_helper'

describe "arguments/show.html.erb" do
  before(:each) do
    @argument = assign(:argument, stub_model(Argument,
      :content => "MyText",
      :user_id => 1,
      :pro => false,
      :argumentable_id => 1,
      :argumentable_type => "Argumentable Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Argumentable Type/)
  end
end

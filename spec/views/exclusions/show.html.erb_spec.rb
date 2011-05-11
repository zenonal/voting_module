require 'spec_helper'

describe "exclusions/show.html.erb" do
  before(:each) do
    @exclusion = assign(:exclusion, stub_model(Exclusion,
      :user_id => 1,
      :excludable_id => 1,
      :excludable_type => "Excludable Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Excludable Type/)
  end
end

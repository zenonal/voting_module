require 'spec_helper'

describe "brainstorms/show.html.erb" do
  before(:each) do
    @brainstorm = assign(:brainstorm, stub_model(Brainstorm,
      :brainstormable_type => "Brainstormable Type",
      :brainstormable_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Brainstormable Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end

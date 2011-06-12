require 'spec_helper'

describe "ideas/index.html.erb" do
  before(:each) do
    assign(:ideas, [
      stub_model(Idea,
        :brainstorm_id => 1,
        :user_id => 1,
        :content_en => "MyText",
        :content_fr => "MyText",
        :content_nl => "MyText"
      ),
      stub_model(Idea,
        :brainstorm_id => 1,
        :user_id => 1,
        :content_en => "MyText",
        :content_fr => "MyText",
        :content_nl => "MyText"
      )
    ])
  end

  it "renders a list of ideas" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end

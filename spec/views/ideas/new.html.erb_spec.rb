require 'spec_helper'

describe "ideas/new.html.erb" do
  before(:each) do
    assign(:idea, stub_model(Idea,
      :brainstorm_id => 1,
      :user_id => 1,
      :content_en => "MyText",
      :content_fr => "MyText",
      :content_nl => "MyText"
    ).as_new_record)
  end

  it "renders new idea form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => ideas_path, :method => "post" do
      assert_select "input#idea_brainstorm_id", :name => "idea[brainstorm_id]"
      assert_select "input#idea_user_id", :name => "idea[user_id]"
      assert_select "textarea#idea_content_en", :name => "idea[content_en]"
      assert_select "textarea#idea_content_fr", :name => "idea[content_fr]"
      assert_select "textarea#idea_content_nl", :name => "idea[content_nl]"
    end
  end
end

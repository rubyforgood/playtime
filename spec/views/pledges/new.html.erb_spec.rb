require 'rails_helper'

RSpec.describe "pledges/new", type: :view do
  before(:each) do
    assign(:pledge, Pledge.new(
      :item_id => 1,
      :user_id => 1
    ))
  end

  it "renders new pledge form" do
    render

    assert_select "form[action=?][method=?]", pledges_path, "post" do

      assert_select "input[name=?]", "pledge[item_id]"

      assert_select "input[name=?]", "pledge[user_id]"
    end
  end
end

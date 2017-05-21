require 'rails_helper'

RSpec.describe "pledges/index", type: :view do
  before(:each) do
    assign(:pledges, [
      Pledge.create!(
        :item_id => 2,
        :user_id => 3
      ),
      Pledge.create!(
        :item_id => 2,
        :user_id => 3
      )
    ])
  end

  it "renders a list of pledges" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end

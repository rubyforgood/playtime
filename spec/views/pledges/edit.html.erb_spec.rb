require 'rails_helper'

RSpec.describe "pledges/edit", type: :view do

  before(:each) do
    @pledge = assign(:pledge, create(:pledge))
  end

  it "renders the edit pledge form" do
    render

    assert_select "form[action=?][method=?]", pledge_path(@pledge), "post" do

      assert_select "input[name=?]", "pledge[wishlist_item_id]"

      assert_select "input[name=?]", "pledge[user_id]"
    end
  end
end

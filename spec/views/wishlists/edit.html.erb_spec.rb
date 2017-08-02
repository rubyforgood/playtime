require 'rails_helper'

RSpec.describe "wishlists/edit", type: :view do
  before(:each) do
    @wishlist = assign(:wishlist, create(:wishlist, name: "DC General"))
    @users = assign(:site_mangers, [create(:user)])
  end

  it "renders the edit wishlist form" do
    render

    assert_select "form[action=?][method=?]", wishlist_path(@wishlist), "post" do

      assert_select "input[name=?]", "wishlist[name]"
    end
  end
end

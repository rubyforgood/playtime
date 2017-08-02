require 'rails_helper'

RSpec.describe "wishlists/new", type: :view do
  before(:each) do
    assign(:wishlist, build(:wishlist, name: "DC Tech"))
    @users = assign(:users, [create(:user)])
  end

  it "renders new wishlist form" do
    render

    assert_select "form[action=?][method=?]", wishlists_path, "post" do

      assert_select "input[name=?]", "wishlist[name]"
    end
  end
end

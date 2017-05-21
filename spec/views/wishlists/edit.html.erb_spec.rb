require 'rails_helper'

RSpec.describe "wishlists/edit", type: :view do
  before(:each) do
    @wishlist = assign(:wishlist, Wishlist.create!(
      :name => "MyText"
    ))
    @site_managers = assign(:site_mangers, [User.create!(
      email: 'email@email.com', site_manager: true
    )])
  end

  it "renders the edit wishlist form" do
    render

    assert_select "form[action=?][method=?]", wishlist_path(@wishlist), "post" do

      assert_select "textarea[name=?]", "wishlist[name]"
    end
  end
end

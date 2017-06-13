require 'rails_helper'

RSpec.describe "wishlists/new", type: :view do
  before(:each) do
    assign(:wishlist, Wishlist.new(
      :name => "MyText"
    ))
    @site_managers = assign(:site_mangers, [User.create!(
      email: 'email@email.com', site_manager: true
    )])
  end

  it "renders new wishlist form" do
    render

    assert_select "form[action=?][method=?]", wishlists_path, "post" do

      assert_select "input[name=?]", "wishlist[name]"
    end
  end
end

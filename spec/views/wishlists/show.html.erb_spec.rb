require 'rails_helper'

RSpec.describe "wishlists/show", type: :view do
  before(:each) do
    @wishlist = assign(:wishlist, Wishlist.create!(
      :name => "MyText"
    ))
    @site_managers = assign(:site_mangers, [User.create!(
      email: 'email@email.com', site_manager: true
    )])
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
  end
end

require 'rails_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
      :name => "Name",
      :email => "Email",
      :admin => false
    ))
    wishlist = Wishlist.create!(name: "Charity")
    item     = Item.create!(name: "Puppy", price_cents: 50)
    wishlist.wishlist_items.create!(item_id: item.id)

    @user.pledges.create!(wishlist_item_id: 1)
    @user.pledges.create!(wishlist_item_id: 1)

    @pledges = @user.pledges
  end



  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/false/)
  end
end

require 'rails_helper'

RSpec.describe "wishlists/index", type: :view do
  before(:each) do
    assign(:wishlists, [
      Wishlist.create!(
        :name => "MyText"
      ),
      Wishlist.create!(
        :name => "MyText"
      )
    ])
  end

  it "renders a list of wishlists" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end

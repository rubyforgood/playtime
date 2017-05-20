require 'spec_helper'

describe User do
  let!(:wishlist) { Wishlist.create!(name: "test") }
  let!(:user)     { User.create!(email: "foo@bar.com") }

  describe "who is a site manager" do
    before { user.site_managers.create!(wishlist: wishlist) }

    it "can manage their site's wishlist" do
      expect(user.can_manage?(wishlist)).to be_truthy
    end
  end

  describe "who is an admin" do
    before { user.update!(admin: true) }

    it "can manage any site's wishlist" do
      expect(user.can_manage?(wishlist)).to be_truthy
    end
  end
end

require "rails_helper"
require "support/omniauth"

feature "Browsing the site:" do
  let!(:dc_general) { create(:wishlist, name: "DC General") }
  let!(:st_josephs) { create(:wishlist, name: "St. Joseph's") }

  context "As a guest" do
    scenario "I can see a list of wishlists" do
      visit "/"

      within "#wishlists" do
        expect(page).to have_link "DC General"
        expect(page).to have_link "St. Joseph's"
      end
    end

    scenario "I can see the details of a wishlist" do
      visit "/"
      click_link "St. Joseph's"

      expect(current_path).to eq wishlist_path(st_josephs)
    end

    # scenario "I can share a wishlist on my social media accounts"
  end
end

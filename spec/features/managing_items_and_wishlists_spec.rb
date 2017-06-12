require "rails_helper"
require "support/omniauth"

feature "Managing items and wishlists:" do
  before do
    create(:wishlist, name: "DC General")
    create(:wishlist, name: "St. Joseph's")
  end

  context "As an admin" do
    before(:each) { login(as: :admin) }
    after(:each)  { reset_amazon_omniauth }

    scenario "I can create a new wishlist" do
      click_link "New Wishlist"
      fill_in("Name", with: "VA General")
      click_button "Create Wishlist"

      expect(page).to have_text "Wishlist was successfully created."
      expect(page).to have_text "VA General"
    end

    scenario "I can update an existing wishlist" do
      click_link "DC General"
      dc_general_path = current_path
      click_link "Edit Wishlist"
      fill_in("Name", with: "VA General")
      click_button "Update Wishlist"

      expect(current_path).to eq dc_general_path
      expect(page).to have_text "Wishlist was successfully updated."
      expect(page).to have_text "VA General"
    end

    scenario "I can delete a wishlist" do
      click_link "DC General"
      within "#wishlist-actions" do
        click_link "Destroy"
      end

      expect(current_path).to eq root_path
      expect(page).to have_text "Wishlist was successfully destroyed."

      within "#wishlists" do
        expect(page).not_to have_link "DC General"
        expect(find_all(".wishlist").count).to eq 1
      end
    end
  end
end

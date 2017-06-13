require "rails_helper"
require "support/omniauth"

feature "Managing items and wishlists:" do
  before do
    create(:wishlist, :with_item, name: "DC General", item_name: "BatCorgi!")
    create(:wishlist, name: "St. Joseph's")
  end

  context "As a site manager" do
    before(:each) { login(as: :site_manager) }
    after(:each)  { reset_amazon_omniauth }

    # scenario "I can add a new item to my wishlist"
    # scenario "I can edit a wishlist item on my wishlist"
    # scenario "I can remove an item from my wishlist"
  end

  context "As an admin" do
    before(:each) { login(as: :admin) }
    after(:each)  { reset_amazon_omniauth }

    # Wishlists

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

    # Items

    scenario "I can add a new item to any wishlist" do
      skip "Implementation requires a working Amazon Product API setup"

      click_link "DC General"
      within "#wishlist-actions" do
        click_link "Add to Wishlist"
      end
      fill_in "search_field", with: "doggo"

      fail "Not fully implemented"
    end

    scenario "I can edit any wishlist item" do
      click_link "DC General"
      within ".wishlist-item-tools" do
        click_link "Edit"
      end
      fill_in("Staff message", with: "Adorable protector of the night!")
      click_button "Update Wishlist item"

      expect(page).to have_text "Wishlist item was successfully updated."
      expect(page).to have_text "Adorable protector of the night!"
    end

    scenario "I can remove an item from any wishlist" do
      click_link "DC General"
      within ".wishlist-item-tools" do
        click_link "Remove"
      end

      expect(page).to have_text "Item was successfully removed from wishlist."
      expect(page).not_to have_text "BatCorgi!"
    end

    # scenario "I can edit any base item listing"
    # scenario "I can delete an item altogether"
  end
end

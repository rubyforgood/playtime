require "rails_helper"
require "support/omniauth"

feature "Managing items and wishlists:" do
  before do
    create(:wishlist, :with_item, name: "DC General", item_name: "BatCorgi!")
    create(:wishlist, name: "St. Joseph's")
  end

  context "As a site manager" do
    before(:each) { login(as: :site_manager, email: "site_manager@example.com") }
    after(:each)  { reset_amazon_omniauth }

    let(:site_manager) { User.find_by(email: "site_manager@example.com") }
    let(:wishlist) { site_manager.wishlists.first }

    scenario "I can add a new item to my wishlist", :external do
      visit wishlist_path(wishlist)
      click_link "Add to Wishlist"
      fill_in "search_field", with: "corgi"
      click_button "Search Amazon"

      # add new item
      within("#search-results") do
        within(find_all(".item").first) do
          fill_in("staff_message", with: "More corgi things!")
          select("18", from: "qty")
          click_button "Add"
        end
      end

      expect(page).to have_text "More corgi things!"
      expect(page).to have_text "Quantity: 18"
    end

    scenario "I can edit a wishlist item on my wishlist" do
      create(:wishlist_item, wishlist: wishlist)

      visit wishlist_path(wishlist)
      within ".wishlist-item-tools" do
        click_link "Edit"
      end
      fill_in("wishlist_item_staff_message",
              with: "Adorable protector of the night!")
      click_button "Update Wishlist item"

      expect(page).to have_text "Wishlist item was successfully updated."
      expect(page).to have_text "Adorable protector of the night!"
    end

    scenario "I can remove an item from my wishlist" do
      create(:wishlist_item, wishlist: wishlist, staff_message: "Another item.")
      visit wishlist_path(wishlist)

      within ".wishlist-item-tools" do
        click_link "Remove"
      end

      expect(page).to have_text "Item was successfully removed from wishlist."
      expect(page).not_to have_text "Another item."
    end

    scenario "I can update my wishlist" do
      visit wishlist_path(wishlist)
      click_link "Edit Wishlist"
      fill_in("wishlist_name", with: "VA General")
      click_button "Update Wishlist"

      expect(current_path).to eq wishlist_path(wishlist)
      expect(page).to have_text "Wishlist was successfully updated."
      expect(page).to have_text "VA General"
    end

    scenario "I can delete my wishlist" do
      visit wishlist_path(wishlist)

      within "#wishlist-actions" do
        click_link "Destroy"
      end

      expect(current_path).to eq root_path
      expect(page).to have_text "Wishlist was successfully destroyed."

      within "#wishlists" do
        expect(page).not_to have_link wishlist.name
        expect(find_all(".wishlist").count).to eq 2
      end
    end

    scenario "I cannot edit someone else's wishlist" do
      dc_general = Wishlist.find_by(name: "DC General")

      visit wishlist_path(dc_general)
      expect(page).not_to have_link "Edit Wishlist"

      visit edit_wishlist_path(dc_general)
      expect(current_path).to eq root_path
      expect(page).to have_text "You are not authorized to view that page."
    end
  end

  context "As an admin" do
    before(:each) { login(as: :admin) }
    after(:each)  { reset_amazon_omniauth }

    # Wishlists

    scenario "I can create a new wishlist" do
      click_link "New Wishlist"
      fill_in("wishlist_name", with: "VA General")
      click_button "Create Wishlist"

      expect(page).to have_text "Wishlist was successfully created."
      expect(page).to have_text "VA General"
    end

    scenario "I can update an existing wishlist" do
      click_link "DC General"
      dc_general_path = current_path
      click_link "Edit Wishlist"
      fill_in("wishlist_name", with: "VA General")
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

    # Site Managers

    scenario "I can add site managers when I'm creating a wishlist" do
      u = create(:user, name: "Sally Ride")
      visit new_wishlist_path

      fill_in "wishlist_name", with: "VA General"
      within "#wishlist_users" do
        check "user-#{u.id}"
      end
      click_button "Create Wishlist"

      within "#site-managers" do
        expect(page).to have_text "Sally Ride"
      end
    end

    scenario "I can add site managers to a wishlist" do
      u = create(:user, name: "Sally Ride")
      click_link "DC General"
      click_link "Edit Wishlist"

      within "#wishlist_users" do
        check "user-#{u.id}"
      end
      click_button "Update Wishlist"

      within "#site-managers" do
        expect(page).to have_text "Sally Ride"
      end
    end

    # Items

    scenario "I can search Amazon for items to add", :external do
      click_link "DC General"
      click_link "Add to Wishlist"
      fill_in "search_field", with: "corgi"
      click_button "Search Amazon"

      within("#search-results") do
        results = find_all(".item")

        # values from saved search response (see fixtures)
        expect(results.count).to eq 10
        expect(page).to have_text "Corgi Socks"
        expect(page).to have_text "Corgi Butt"
      end
    end

    scenario "I can add a new item to the wishlist", :external do
      click_link "DC General"
      click_link "Add to Wishlist"
      fill_in "search_field", with: "corgi"
      click_button "Search Amazon"

      # add new item
      within("#search-results") do
        within(find_all(".item").first) do
          fill_in("staff_message", with: "More corgi things!")
          select("18", from: "qty")
          click_button "Add"
        end
      end

      expect(page).to have_text "More corgi things!"
      expect(page).to have_text "Quantity: 18"
    end
    # context "when the Amazon service is down"

    scenario "I can edit any wishlist item" do
      click_link "DC General"
      within ".wishlist-item-tools" do
        click_link "Edit"
      end
      fill_in("wishlist_item_staff_message",
              with: "Adorable protector of the night!")
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

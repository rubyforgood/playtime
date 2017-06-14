require "rails_helper"
require "support/omniauth"

feature "Managing Users:" do
  context "As an admin" do
    before(:each) {
      2.times { create(:user) }
      login(as: :admin, email: "admin@example.com")
    }
    after(:each) { reset_amazon_omniauth }

    scenario "I can view a list of users" do
      click_link "Users"
      within "#users" do
        expect(find_all(".user").count).to eq 3
      end
    end

    scenario "I can view details on an individual user" do
      click_link "Users"
      users = find_all(".user")
      within(users.first) do
        click_link "Show"
      end

      expect(page).to have_css "#user-details"
      expect(page).to have_text "Name"
      expect(page).to have_text "Email"
    end

    scenario "I can update a user's account details" do
      click_link "Users"
      users = find_all(".user")
      within(users.first) do
        click_link "Edit"
      end

      within "form" do
        fill_in "user_name", with: "Gus Grissom"
        click_button "Update User"
      end

      expect(page).to have_text "User was successfully updated."
      expect(page).to have_text "Gus Grissom"
    end

    scenario "I can delete a user account" do
      click_link "Users"
      users = find_all(".user")
      within(users.first) do
        click_link "Destroy"
      end

      expect(page).to have_text "User was successfully destroyed."
      expect(current_path).to eq users_path
      expect(find_all(".user").count).to eq 2
    end

    scenario "I can export the list of users to a CSV file" do
      click_link "Users"
      click_link "Export CSV"

      expect(page).to have_text "id,"               # should be a csv...
      expect(page).to have_text "admin@example.com" # ...with user data
    end

    # scenario "I can assign a user to be Site Manager of a wishlist"
  end
end

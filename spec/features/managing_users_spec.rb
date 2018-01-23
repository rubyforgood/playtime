# frozen_string_literal: true

require 'rails_helper'
require 'support/omniauth'

feature 'Managing Users:' do
  context 'As a user' do
    before(:each) { login(as: :user, email: 'user@example.com') }
    after(:each) { reset_amazon_omniauth }

    scenario 'I can view my own user page' do
      click_link 'user@example.com'
      expect(page).to have_text 'Email: user@example.com'
    end

    scenario 'I can edit my own identity information' do
      click_link 'user@example.com'
      click_link 'Edit'

      expect(page).not_to have_text 'Admin'

      fill_in 'Name', with: 'Bill Nye'
      click_button 'Update User'

      expect(page).to have_text 'Bill Nye'
    end

    scenario 'I can delete my own account' do
      click_link 'user@example.com'
      click_link 'Edit'
      click_link 'Delete Account'

      expect(current_path).to eq root_path
      expect(page).to have_text 'Log In'
      expect(page).to have_text 'You have successfully deleted your account.'
    end
  end

  context 'As an admin' do
    before(:each) do
      2.times { create(:user) }
      login(as: :admin, email: 'admin@example.com')
    end
    after(:each) { reset_amazon_omniauth }

    scenario 'I can view a list of users' do
      click_link 'Users'
      within '#users' do
        expect(find_all('.user').count).to eq 3
      end
    end

    scenario 'I can view details on an individual user' do
      click_link 'Users'
      users = find_all('.user')
      within(users.first) do
        click_link 'Show'
      end

      expect(page).to have_css '#user-details'
      expect(page).to have_text 'Email'
      expect(page).to have_text 'Email'
    end

    scenario "I can update a user's account details" do
      click_link 'Users'
      users = find_all('.user')
      within(users.first) do
        click_link 'Edit'
      end

      within 'form' do
        fill_in 'user_name', with: 'Gus Grissom'
        click_button 'Update User'
      end

      expect(page).to have_text 'User was successfully updated.'
      expect(page).to have_text 'Gus Grissom'
    end

    scenario 'I can delete a user account' do
      user = create(:user) # so we're not deleting our own account

      click_link 'Users'
      users = find_all('.user')
      target_user_node = users.find { |user_element| user_element.text.include?(user.email) }
      within(target_user_node) do
        click_link 'Destroy'
      end

      expect(page).to have_text 'User was successfully destroyed.'
      expect(current_path).to eq users_path
      expect(find_all('.user').count).to eq 3
    end

    scenario 'I can export the list of users to a CSV file' do
      click_link 'Users'
      click_link 'Export CSV'

      expect(page).to have_text 'name,email,'       # should be a csv...
      expect(page).to have_text 'admin@example.com' # ...with user data
    end

    scenario 'I see user pledging history on the user page' do
      user = create(:user)
      2.times { create(:pledge, user: user) }

      visit user_path(user)
      expect(find_all('.pledge').count).to eq 2
    end

    scenario 'I can assign a user as an admin' do
      visit users_path
      within find_all('.user').first do
        click_link 'Edit'
      end
      check 'user_admin'
      click_button 'Update User'

      expect(page).to have_text 'Admin'
    end

    scenario 'I can assign a user as a site manager for a wishlist' do
      dc_tech = create(:wishlist, name: 'DC General')
      jh = create(:wishlist, name: "Joseph's House")
      visit users_path

      within find_all('.user').first do
        click_link 'Edit'
      end
      within '#user_wishlists' do
        check "wishlist-#{dc_tech.id}"
        check "wishlist-#{jh.id}"
      end
      click_button 'Update User'

      within '#user-wishlists' do
        expect(page).to have_link 'DC General'
        expect(page).to have_link "Joseph's House"
      end
    end

    scenario 'I can unassign a user as a site manager for a wishlist' do
      user = create(:user, :with_sites, site_count: 2)
      wishlist = user.wishlists.first
      visit edit_user_path(user)

      within '#user_wishlists' do
        uncheck "wishlist-#{wishlist.id}"
      end
      click_button 'Update User'

      expect(find_all('.user-wishlist').count).to eq 1
    end
  end
end

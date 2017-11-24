# frozen_string_literal: true

require 'rails_helper'
require 'support/omniauth'

feature 'Browsing the site:' do
  let!(:dc_general) { create(:wishlist, name: 'DC General') }
  let!(:st_josephs) { create(:wishlist, name: "St. Joseph's") }

  context 'As a guest' do
    scenario 'I can see a list of wishlists' do
      visit '/'

      within '#wishlists' do
        expect(page).to have_link 'DC General'
        expect(page).to have_link "St. Joseph's"
      end
    end

    scenario 'I can see the details of a wishlist' do
      visit '/'
      click_link "St. Joseph's"

      expect(current_path).to eq wishlist_path(st_josephs)
    end

    context 'when there are wishlist items' do
      before do
        create(:item, :on_a_wishlist, wishlist: dc_general, name: 'BatCorgi!')
        create(:item, :on_a_wishlist, wishlist: st_josephs, name: 'Puzzles')
      end

      scenario 'I can see a list of items across all wishlists' do
        visit '/'

        expect(page).to have_text 'BatCorgi!'
        expect(page).to have_text 'Puzzles'
        expect(page).to have_button 'Pledge to Donate'
      end

      scenario 'I can see a list of items for a given wishlist' do
        visit '/'
        click_link 'DC General'

        expect(page).to have_text 'BatCorgi!'
        expect(page).to_not have_text 'Puzzles'
      end
    end

    # scenario "I can share a wishlist on my social media accounts"
  end
end

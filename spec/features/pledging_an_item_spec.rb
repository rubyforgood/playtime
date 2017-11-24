# frozen_string_literal: true

require 'rails_helper'
require 'support/omniauth'

feature 'Pledging an item:' do
  before do
    create(:pledge, user: create(:user, name: 'Bill Gates'))
  end

  context 'As a guest' do
    scenario 'I can pledge an item' do
      visit root_path
      click_button 'Pledge to Donate'
      expect(page).to have_text 'You pledged to donate'
      # TODO: expect a new tab to open to Amazon
    end

    scenario 'I can unpledge an anonymous pledge' do
      pledge = create(:pledge, user: nil)
      visit pledge_path(pledge)
      within('.pledge') { click_link 'Unpledge' }
      expect(page).to have_text 'Pledge was successfully destroyed'
    end

    scenario 'I can update the quantity of an anonymous pledge' do
      pledge = create(:pledge, user: nil)
      visit edit_pledge_path(pledge)
      fill_in 'pledge_quantity', with: '3'
      click_button 'Update Pledge'

      expect(page).to have_text 'Pledge was successfully updated'
      expect(page).to have_text 'Number pledged 3'
    end
  end

  context 'As a user' do
    before { login(as: :user) }
    after { reset_amazon_omniauth }

    scenario 'I can pledge an item' do
      visit root_path
      click_button 'Pledge to Donate'
      expect(page).to have_text 'You pledged to donate'
      # TODO: expect a new tab to open to Amazon
    end

    scenario 'I can claim an anonymous item' do
      pledge = create(:pledge, user: nil)
      visit pledge_path(pledge)
      click_link 'Claim pledge'
      expect(page).to have_text 'You have claimed this pledge'
    end

    scenario 'I can claim a duplicate anonymous item' do
      current_user = User.last
      wishlist_item = create(:wishlist_item)
      create(:pledge, wishlist_item: wishlist_item, user: current_user)
      pledge = create(:pledge, wishlist_item: wishlist_item)

      visit pledge_path(pledge)
      click_link 'Claim pledge'
      expect(page).to have_text 'You have claimed this pledge'
    end
  end

  context 'As the pledging user' do
    let!(:user) { create(:user, email: 'pledging_user@example.com') }
    let!(:pledge) { create(:pledge, user: user) }

    before { login(as: :user, email: user.email) }
    after { reset_amazon_omniauth }

    scenario 'I can unpledge an item I pledged from my user page' do
      visit user_path(user)
      within(find_all('.pledge').first) { click_link 'Unpledge' }

      expect(page).to have_text 'Pledge was successfully destroyed'
    end

    scenario 'I can unpledge an item I pledged from the pledge page' do
      visit pledge_path(pledge)
      within('.unpledge') { click_link 'Unpledge' }

      expect(page).to have_text 'Pledge was successfully destroyed'
    end

    scenario 'I can edit the quantity of my pledge' do
      visit pledge_path(pledge)
      within('.pledge') { click_link 'Edit' }
      fill_in 'pledge_quantity', with: '3'
      click_button 'Update Pledge'

      expect(page).to have_text 'Pledge was successfully updated'
      expect(page).to have_text 'Number pledged 3'
    end

    scenario 'I can re-pledge an item to increment its quantity' do
      visit wishlist_path(pledge.wishlist)
      click_button 'Pledge to Donate'
      expect(page).to have_text 'Number pledged 2'
    end
  end

  context 'As an admin' do
    before { login(as: :admin) }
    after { reset_amazon_omniauth }

    scenario 'I can view a list of pledges' do
      click_link 'Pledges'
      expect(find_all('.pledge').count).to eq 1
    end

    scenario 'I can view pledge details' do
      visit pledges_path
      click_link 'Show'
      thank_you_note = 'Thanks for being a Hero of Play! On behalf of the children and families we serve, thank you!'
      expect(page).to have_text thank_you_note
    end

    scenario 'I can edit the quantity of an existing pledge' do
      visit pledges_path
      click_link 'Edit'
      fill_in 'pledge_quantity', with: '3'
      click_button 'Update Pledge'

      expect(page).to have_text 'Pledge was successfully updated'
      expect(page).to have_text 'Number pledged 3'
    end

    scenario 'I can unpledge an existing pledge' do
      visit pledges_path
      within find_all('.pledge').first do
        click_link 'Unpledge'
      end

      expect(find_all('.pledge').count).to eq 0
    end

    scenario 'I can export pledges as a CSV file' do
      visit pledges_path
      click_link 'Export CSV'

      expect(page).to have_text 'user,'      # should be a csv...
      expect(page).to have_text 'Bill Gates' # ...with pledge data
    end
  end
end

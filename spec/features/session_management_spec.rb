# frozen_string_literal: true

require 'rails_helper'
require 'support/omniauth'

feature 'Session Management:' do
  context 'As a guest' do
    context 'using my existing Amazon login credentials' do
      before(:each) { setup_amazon_omniauth(email: 'user@example.com') }
      after(:each)  { reset_amazon_omniauth }

      scenario 'I can create an account' do
        visit '/'
        click_link 'Log In'

        expect(page).to have_link 'Log Out'
      end

      scenario 'I can log into an existing account' do
        create(:user, email: 'user@example.com', name: 'Bartleby')
        login(email: 'user@example.com')

        expect(page).to have_text 'Bartleby'
      end
    end
  end

  context 'As a logged-in user' do
    before(:each) { login(email: 'user@example.com') }
    after(:each)  { reset_amazon_omniauth }

    scenario 'I can log out of my account' do
      click_link 'Log Out'

      expect(page).not_to have_text 'user@example.com'
      expect(page).to have_link 'Log In'
    end
  end
end

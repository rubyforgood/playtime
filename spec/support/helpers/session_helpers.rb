# frozen_string_literal: true

require 'support/factory_bot'

module Helpers
  module SessionHelpers
    def setup_amazon_omniauth(email: 'user@example.com', **custom_params)
      OmniAuth.config.mock_auth[:amazon] = OmniAuth::AuthHash.new({
        provider: 'amazon',
        info: { email: email },
        extra: { postal_code: 54321 }
      }.merge(custom_params))
    end

    def reset_amazon_omniauth
      OmniAuth.config.mock_auth[:amazon] = nil
    end

    def login(email: 'user@example.com', as: nil, **custom_params)
      create(:admin, email: email) if as == :admin
      create(:user, :with_sites, email: email) if as == :site_manager
      setup_amazon_omniauth(email: email, **custom_params)

      visit '/'
      click_link 'Log In'
    end
  end
end

RSpec.configure { |c| c.include Helpers::SessionHelpers }

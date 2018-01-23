# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :amazon, ENV['AMAZON_CLIENT_ID'], ENV['AMAZON_CLIENT_SECRET'],
           scope: 'profile postal_code' # default scope

  provider :developer if Rails.env.development?
end

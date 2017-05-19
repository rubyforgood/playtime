Rails.application.config.middleware.use OmniAuth::Builder do
  provider :amazon, ENV['AMAZON_CLIENT_ID'], ENV['AMAZON_CLIENT_SECRET'],
    {
      :scope => 'profile postal_code' # default scope
    }
end

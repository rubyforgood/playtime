source 'https://rubygems.org'

ruby '2.4.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# A Ruby gem to load environment variables from `.env`.
gem 'dotenv-rails'
# Logs production errors to an external service
gem 'rollbar'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# A gem to automate using jQuery with Rails
gem 'jquery-rails', '~> 4.3.1'

# required for Bootstrap tooltips
source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.3.3'
end
# The most popular HTML, CSS, and JavaScript framework for developing responsive, mobile first projects on the web.
gem 'bootstrap', '~> 4.0.0.alpha6'
# Login with Amazon OAuth2 strategy for OmniAuth 1.0
gem 'omniauth-amazon'
# Makes http fun again! http://jnunemaker.github.com/httparty
gem 'httparty'
# Helper for add social share feature in your Rails app. Twitter, Facebook, Weibo, Douban
gem 'social-share-button', '~> 1.0.0'
# most important gem for awesome debugging and awesome consoles
gem 'pry-rails'
# Authorizaton library
gem 'pundit'

gem 'font-awesome-sass'
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  # WebDriver is a tool for writing automated tests of websites. It aims to mimic the behaviour of a real user, and as such interacts with the HTML of the application.
  gem 'selenium-webdriver'
  # rspec-rails is a testing framework for Rails 3+.
  gem 'rspec-rails', '~> 3.5'
  # Fixtures replacement. Read more: http://www.rubydoc.info/gems/factory_girl/
  gem 'factory_girl_rails', '~> 4.8'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  # Annotate model/model spec/factory files with the database schema
  gem 'annotate', '~> 2.7'
  # The Listen gem listens to file modifications and notifies you about the changes. https://rubygems.org/gems/listen
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # This gem makes Spring watch the filesystem for changes using Listen rather than by polling the filesystem.
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Implements the `rspec` command for Spring, allowing for faster test loading
  gem 'spring-commands-rspec', '~> 1.0'
  # Helps detect N+1 queries and unused eager loading
  gem 'bullet'
end

group :test do
  # Allows you to launch a debugging snapshot in your browser during Capybara tests
  gem 'launchy', '~> 2.4.3'
  # A set of strategies for cleaning your database (ensuring a clean slate during tests)
  gem 'database_cleaner', '~> 1.6.1'
  # Library for stubbing and setting expectations on HTTP requests in Ruby.
  gem 'webmock', '~> 3.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

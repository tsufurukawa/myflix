source 'https://rubygems.org'
ruby '2.1.1'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'bcrypt-ruby'
gem 'bootstrap_form'
gem 'fabrication'
gem 'faker'
gem 'sidekiq'
gem 'unicorn'
gem 'sentry-raven'
gem 'paratrooper'
gem 'fog'
gem 'carrierwave'
gem 'mini_magick'
gem 'figaro'
gem 'stripe'
gem 'draper'
gem 'stripe_event'

group :development do
  gem 'sqlite3'
  gem 'pry-nav'
  gem 'thin'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
end

group :test, :development do 
  gem 'rspec-rails', '~> 3.0.0'
  gem 'pry'
end

group :test do
  gem 'shoulda-matchers'
  gem 'database_cleaner', '~> 1.3.0'
  gem 'capybara'
  gem 'capybara-email', github: 'dockyard/capybara-email'
  gem 'launchy'
  gem 'vcr'
  gem 'webmock'
  gem 'selenium-webdriver'
  gem 'capybara-webkit'
end

group :production, :staging do
  gem 'pg'
  gem 'rails_12factor'
end




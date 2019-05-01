source 'https://rubygems.org'
source 'https://rails-assets.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'devise', '>= 4.6.0'
gem 'devise-security'
gem 'kaminari'

gem 'rolify'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec'
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'rspec_junit_formatter'
  gem 'simplecov'
  gem 'shoulda-matchers', require: false

  gem 'sniffybara', git: 'https://github.com/department-of-veterans-affairs/sniffybara.git'

  gem 'rspec-retry'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rails-erd'
  gem 'letter_opener'
  gem 'figaro'

  # To be able to automagically generate domain model ER diagrams, https://github.com/amatsuda/erd
  # Requires graphviz installed locally
  # Use this to create and update models and migrations
  # Use: localhost:3000/erd
  gem 'erd'

  ###
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'jquery-rails'
gem 'uswds-rails', github: 'agilesix/uswds-rails', branch: 'update-2.0.1'

gem 'activerecord-nulldb-adapter'
gem 'acts_as_list'
gem 'aws-sdk-s3'
gem 'paperclip', '~> 6.0.0'
gem 'font-awesome-sass', '~> 5.6.1'
gem 'sidekiq'

gem 'survey_monkey_api', github: 'agilesix/surveymonkey'
gem 'mechanize'

gem 'roo', '~> 2.8.0'

gem 'friendly_id', '~> 5.2.4'

gem 'papercrop'
gem 'rails-assets-sticky', source: 'https://rails-assets.org'
gem 'rails-assets-jquery.scrollTo', source: 'https://rails-assets.org'

source 'https://rubygems.org'
source 'https://rails-assets.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5.2.4.3'
# Use postgresql as the database for Active Record
gem 'pg', '1.1.4'
# gem 'pg', '1.1.4',  platforms: [:mingw, :x64_mingw]
# Use Puma as the app server
gem 'puma', '>= 4.3.5'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'mini_racer', platforms: :ruby

gem 'babel-transpiler'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis'

gem 'hiredis'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.13'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '1.4.4', require: false

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
  gem 'rspec_junit_formatter'
  gem 'simplecov'
  gem 'shoulda-matchers', require: false
  gem 'pry', '~> 0.12.2'

  # gem 'sniffybara', git: 'https://github.com/department-of-veterans-affairs/sniffybara.git'
  gem 'figaro'
  gem 'rspec-retry'
  gem 'axe-matchers'
  gem 'webdrivers'

  gem 'brakeman', '>= 4.7.1'
  gem 'bundler-audit'
  gem 'bundler-leak'
  gem 'json', '>= 2.3.0'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '3.1.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rails-erd'
  gem 'letter_opener'

  # To be able to automagically generate domain model ER diagrams, https://github.com/amatsuda/erd
  # Requires graphviz installed locally
  # Use this to create and update models and migrations
  # Use: localhost:3000/erd
  gem 'erd'

  gem 'rubyzip'

  ###
end
gem 'ffi', '1.11.1'
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'uswds-rails', github: 'agilesix/uswds-rails', branch: '2.8.1'

gem 'activerecord-nulldb-adapter'
gem 'acts_as_list'
gem 'aws-sdk-s3'
gem 'paperclip', '~> 6.0.0'
gem 'font-awesome-sass', '~> 5.13.0'
gem 'sidekiq'

gem 'survey_monkey_api', github: 'agilesix/surveymonkey'
gem 'mechanize', '2.7.6'

gem 'roo', '~> 2.8.0'

gem 'friendly_id', '~> 5.2.4'

gem 'jquery-cropper'

gem 'rails-assets-sticky', source: 'https://rails-assets.org'
gem 'rails-assets-jquery.scrollTo', source: 'https://rails-assets.org'
gem "nested_form"
gem 'colorize'
gem 'humanize'
gem 'paper_trail'
gem 'commontator'
gem 'acts_as_votable'
gem 'jquery-timeago-rails', github: 'agilesix/jquery-timeago-rails'

# Active Admin
gem 'activeadmin'
gem 'activeadmin_addons'
gem 'active_skin'
gem 'active_admin_theme'
gem 'caxlsx'
gem 'activeadmin_quill_editor'

gem "chartkick"
gem 'groupdate'

gem 'ahoy_matey'

gem 'ntlm-sso', github: 'agilesix/ntlm-sso', ref: 'master'
gem 'net-ldap'

gem 'wdm', '>= 0.1.0' if Gem.win_platform?

gem 'gmaps4rails', github: 'agilesix/Google-Maps-for-Rails', ref: 'master'
gem 'lodash-rails'

gem 'route_downcaser'

source 'https://rubygems.org'

ruby '3.2.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1'
# Use postgresql as the database for Active Record
gem 'pg'
# gem 'pg', '1.1.4',  platforms: [:mingw, :x64_mingw]
# Use Puma as the app server
gem 'puma', '~> 6.4.2'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes

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
gem 'bootsnap', require: false

gem 'devise', '>= 4.6.0'
gem 'devise-security'
gem 'kaminari'

gem 'rolify', '~> 5.3.0'
# pagination gem
gem 'pagy', '~> 4'

gem 'local_time'
gem 'rails-timeago'

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
  gem 'pry'
  gem 'rack_session_access'

  # gem 'sniffybara', git: 'https://github.com/department-of-veterans-affairs/sniffybara.git'
  gem 'figaro'
  gem 'rspec-retry'
  gem 'axe-matchers'
  gem 'webdrivers'

  gem 'brakeman', '5.0.2'
  gem 'bundler-audit'
  gem 'bundler-leak'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-performance', require: false

end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rails-erd'
  gem 'letter_opener'
  gem 'bullet'

  # To be able to automagically generate domain model ER diagrams, https://github.com/amatsuda/erd
  # Requires graphviz installed locally
  # Use this to create and update models and migrations
  # Use: localhost:3000/erd
  gem 'erd'

  gem 'rubyzip'
  gem 'sprockets'

  ###
end

gem 'ffi'
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'jquery-rails'
# pinned until maintainers publish to RubyGems
gem 'jquery-ui-rails', github: 'jquery-ui-rails/jquery-ui-rails', tag: 'v7.0.0'
gem 'uswds-rails', github: 'agilesix/uswds-rails', ref: '52da189'

gem 'activerecord-nulldb-adapter'
gem 'acts_as_list'
gem 'aws-sdk-s3'
gem 'aws-sdk-rds'
gem 'wt_s3_signer'
gem 'paperclip', github: 'agilesix/paperclip', branch: 'ruby-3-2-patched'
gem 'font-awesome-sass', '~> 5.13.0'

gem 'survey_monkey_api', github: 'agilesix/surveymonkey'
gem 'mechanize', '2.8.5'

gem 'roo', '~> 2.8.0'

gem 'friendly_id', '~> 5.2.4'

gem 'jquery-cropper'

source 'https://rails-assets.org' do
  gem 'rails-assets-jquery'
  gem 'rails-assets-sticky'
  gem 'rails-assets-jquery.scrollTo'
  gem 'rails-assets-normalize-css' # force dependency for uswds-rails to load from rails-assets
end
gem "nested_form"
gem 'colorize'
gem 'humanize'
gem 'paper_trail'
gem 'commontator', '~> 6.3.1'
gem 'acts_as_votable'
gem 'json', '~> 2.3.0'

# Active Admin
gem 'activeadmin', '~> 3.2.0'
gem 'activeadmin_addons'
gem 'active_skin'
gem 'active_admin_theme'
gem 'caxlsx'
gem 'tinymce-rails', '6.8.3'

gem 'sassc'

gem "chartkick"
gem 'groupdate'

gem 'ahoy_matey'

gem 'ntlm-sso', github: 'agilesix/ntlm-sso', branch: 'master'
gem 'net-ldap'

gem 'wdm', '>= 0.1.0' if Gem.win_platform?

gem 'gmaps4rails', github: 'agilesix/Google-Maps-for-Rails', branch: 'master'
gem 'lodash-rails'

gem 'route_downcaser'

gem "autoprefixer-rails"
gem 'naturalsorter', '3.0.22'
gem 'opentelemetry-sdk'
gem 'opentelemetry-exporter-otlp'
gem 'opentelemetry-instrumentation-all'
gem 'recaptcha', require: 'recaptcha/rails'

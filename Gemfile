source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.13'
gem 'pg' #postgresql

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer', '0.10.2', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

group :test, :development do
  gem 'rspec-rails' # rspec
  gem 'factory_girl_rails' # makes testing easier by creating factories for models
  gem 'capybara' # acceptance testing language, makes rspecs easier to write
  gem 'jasmine' # behavior-driven development framework for testing JavaScript code
  gem 'poltergeist' # phantom js driver for capybara headless testing
  gem 'capybara-webkit' # another headless testing JS interpreter
  gem 'database_cleaner' # used by test framework
  gem 'guard' # auto runs rspecs
  gem 'guard-rspec' # auto runs rspecs
  gem 'faker' # creates fake data for tests
  gem 'launchy' # launches browser when tests fail
  gem 'better_errors' # replaces standard error page with better errors
  gem 'binding_of_caller' # used by better errors for advanced features
  gem 'debugger' # real time debugging
  gem 'spring' # faster rspec tests
  gem 'libnotify' # growl-like notification
end

gem 'json'
gem 'jquery-rails' # so we dont have to manage jquery, i guess that's cool
gem 'jquery-ui-rails' # jquery ui
gem 'less-rails' # less css preprocessor
gem 'twitter-bootstrap-rails' # bootstrap. boom.
gem 'bootstrap-wysihtml5-rails' # wysiwyg editor
gem 'rails-backbone' # backbone (in coffee)
gem 'bcrypt-ruby', :require => 'bcrypt' # slick crypto shit
gem 'jbuilder' # serves .json.jbuilder type files in views
gem 'paperclip' # used for file uploads
gem 'jquery-fileupload-rails' # front-end file upload js
gem 'thin' # webserver
gem 'aws-sdk' # amazon toolkit for S3
gem 'delayed_job_active_record' # delayed job
gem 'sendgrid' # sendgrid tools
gem 'gridhook' # sendgrid webhook helper


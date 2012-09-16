# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/poltergeist'
require 'capybara/rspec'
require 'capybara/rails'
require 'paperclip/matchers'

# cool headless js engine
Capybara.javascript_driver = :poltergeist

# set screenshot directory and clear before each run
ScreenshotPath = Rails.root.join("spec/screenshots/")
Dir.glob("#{ScreenshotPath}*.png") do |file|
  next if file == '.' or file == '..'
  File.delete(file)
end

# options are :deletion, :transation or :truncation
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# shutup airbrake
module Airbrake
  def self.notify(exception, opts = {})
    # do nothing.
  end
end

RSpec.configure do |config|

  config.include Paperclip::Shoulda::Matchers

  # macros
  config.include(UserLogin)
  config.include(ScreenShot)

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  #  config.use_transactional_fixtures = false 

  # run once before each 'describe' group
  config.before(:suite) do
    DatabaseCleaner.clean
    DatabaseCleaner.start
  end

  config.after(:suite) do
    DatabaseCleaner.clean
  end
  
  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  # config.infer_base_class_for_anonymous_controllers = false

end



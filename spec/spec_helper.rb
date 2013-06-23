require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/poltergeist'
require 'capybara/rspec'
require 'capybara/rails'
require 'paperclip/matchers'

# js engine
#Capybara.javascript_driver = :poltergeist
Capybara.javascript_driver = :webkit
#Capybara.javascript_driver = :selenium

## javascript event wait time
Capybara.default_wait_time = 5

# set screenshot directory and clear before each run
ScreenshotPath = Rails.root.join("spec/screenshots/")
Dir.mkdir ScreenshotPath if !File.directory? ScreenshotPath
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

RSpec.configure do |config|

  config.include Paperclip::Shoulda::Matchers

  # macros
  config.include UserLogin
  config.include ScreenShot 

  # run once before each 'describe' group
  config.before(:suite) do
    DatabaseCleaner.clean
    DatabaseCleaner.start
  end

  config.after(:suite) do
    DatabaseCleaner.clean    
  end

  config.after(:all) do
    # clean up tmp files
    if File::directory? "tmp/fixtures"
      # FileUtils.rm_rf "tmp/fixtures"
    end  
  end

end









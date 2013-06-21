require 'rubygems'
require 'spork'

# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
Spork.prefork do

  ENV["RAILS_ENV"] ||= 'test'

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
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
      if File::directory?("tmp/fixtures")
        FileUtils.rm_rf(DIR["tmp/fixtures"]) 
      end  
    end

  end

end

# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
Spork.each_run do


  require 'factory_girl_rails'

  # reload all the models
  Dir["#{Rails.root}/app/models/**/*.rb"].each do |model|
    load model 
  end

  # reload all factories
  FactoryGirl.factories.clear
  FactoryGirl.sequences.clear
  Dir.glob("#{::Rails.root}/spec/factories/*.rb").each do |file|
    load "#{file}"
  end
end







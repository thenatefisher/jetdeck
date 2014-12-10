# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Rails.logger = Logger.new(STDOUT)
Jetdeck::Application.initialize!

# Use SendGrid
ActionMailer::Base.smtp_settings = {
  :user_name => "jetdeck",
  :password => "xxx",
  :domain => "jetdeck.co",
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}

ActiveRecord::Base.logger.level = 1
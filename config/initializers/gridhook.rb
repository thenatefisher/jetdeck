require "#{Rails.root}/lib/gridhook/email_event_processor" 

Gridhook.configure do |config|
    
  # The path we want to receive events
  config.event_receive_path = '/sendgrid/event'

  config.event_processor = proc {|p| Rails.logger.info p.inspect} 

end
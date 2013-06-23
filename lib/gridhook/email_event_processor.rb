class EmailEventProcessor
  def call(event)

    Rails.logger.info  "from sendgrid: #{event.inspect}"
    
    a = Airframe.first

  end
end
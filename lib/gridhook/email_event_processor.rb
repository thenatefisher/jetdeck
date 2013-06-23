class EmailEventProcessor
  def call(event)
    logger = Logger.new(STDOUT)
    logger.error "from sendgrid: #{event.inspect}"
    
    a = Airframe.first

  end
end
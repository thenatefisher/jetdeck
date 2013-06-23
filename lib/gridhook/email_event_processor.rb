class EmailEventProcessor
  def call(event)
    # all of your application-specific code here - creating models,
    # processing reports, etc
    logger = Logger.new(STDOUT)
    logger.error "from sendgrid: #{event.inspect}"
  end
end
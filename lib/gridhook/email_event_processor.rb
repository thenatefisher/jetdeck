class EmailEventProcessor

  def call(event)

    puts "INPUT EVENT: #{event[:event]}"
    puts "INPUT MESSAGE_ID: #{event[:airframe_message_id]}"

    return true if event[:airframe_message_id].blank?

    message = AirframeMessage.find(event[:airframe_message_id].to_i)

    case event[:event].downcase.strip
    when "delivered"
      message.status = "sent"
    when "open"
      message.status = "opened"
    when "bounce"
      message.status = "bounced"
    when "dropped"
      message.status = "failed"
    end

    message.save
    puts "MESSAGE: #{message.inspect}"
      
  end

end

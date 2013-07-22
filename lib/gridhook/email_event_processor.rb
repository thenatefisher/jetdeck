class EmailEventProcessor

  def call(event)

    return true if event[:airframe_message_id].blank?

    AirframeMessage.find(event[:airframe_message_id].to_i) do |message|

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

    end

  end

end

class EmailEventProcessor

  def call(event)

    return true if event[:airframe_message_id].blank?

    AirframeMessage.find(event[:airframe_message_id].to_i) do |message|

      next if event[:event].blank?

      case event[:event].downcase
      when "delivered"
        message.status = "sent"
      when "open"
        message.status = "opened"
      when "bounce"
        message.status = "bounced"
      when "dropped"
        message.status = "failed"
      end

      begin
        message.save!
      rescue error
        puts error.message
      end

    end

    return true

  end

end

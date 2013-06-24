class EmailEventProcessor

  def call(event)

    return true if event[:airframe_message_id].blank?

    AirframeMessage.find(event[:airframe_message_id].to_i) do |message|

        next if event[:event].blank?

        case event[:event].downcase
            when "delivered"
                message.status_date = Time.now
                message.status = "sent"
            when "open"
                message.status_date = Time.now
                message.status = "opened"
            when "bounce"
                message.status_date = Time.now
                message.status = "bounced"
            when "dropped"
                message.status_date = Time.now
                message.status = "failed"
        end
        
        message.save!

    end

  end

end
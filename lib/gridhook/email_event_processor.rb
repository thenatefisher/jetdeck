class EmailEventProcessor
  def call(events)

    events.each do |event|
        AirframeMessage.find(event.airframe_message_id) do |message|

            case event.event
                when "processed"
                    message.status_date = Time.now
                    message.status = "sent"
                when "delivered"
                    message.status_date = Time.now
                    message.status = "opened"
                when "bounced"
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
end
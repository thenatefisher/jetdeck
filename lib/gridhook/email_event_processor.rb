class EmailEventProcessor
  def call(events)
    puts "====== IN EMAIL EVENT PROCESSOR ======"
    events.each do |event|
        AirframeMessage.find(event.airframe_message_id) do |message|

            case event.event.downcase
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
end
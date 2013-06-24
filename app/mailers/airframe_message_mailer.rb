class AirframeMessageMailer < ActionMailer::Base
  include SendGrid

  default from: "JetDeck.co <noreply@jetdeck.co>"
  sendgrid_enable :ganalytics

  def sendMessage(airframe_message)
    sendgrid_enable :opentrack
    sendgrid_category "airframe-message"
    sendgrid_unique_args :airframe_message_id => airframe_message.id

    if airframe_message.spec_enabled
      @filename = airframe_message.airframe_spec.spec_file_name
      @filesize = "#{(airframe_message.airframe_spec.spec_file_size / 1000).to_i}Kb"
      @spec_link = "#{root_url}s/#{airframe_message.spec_url_code}"
    end

    if airframe_message.photos_enabled
      @filename = airframe_message.airframe_spec.spec_file_name
      @filesize = "#{(airframe_message.airframe_spec.spec_file_size / 1000).to_i}Kb"
      @photos_link = (airframe_message.photos_enabled) ? 
        "#{root_url}p/#{airframe_message.photos_url_code}" : nil
    end
    
    @favicon = "#{root_url}/assets/favicon.png"
    @body = airframe_message.body

    status = mail(:to => airframe_message.recipient.emailField,
                 :subject => airframe_message.subject,
                 :from => airframe_message.creator.contact.emailField) do |format|
      format.text
      format.html
    end
    
    airframe_message.status = "sending"
    airframe_message.save!

  end

end

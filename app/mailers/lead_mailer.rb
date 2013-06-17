class LeadMailer < ActionMailer::Base
  default from: "JetDeck.co <noreply@jetdeck.co>"

  def sendSpec(lead)
    
    @filename = lead.spec.document_file_name
    @filesize = "#{(lead.spec.document_file_size / 1000).to_i}Kb"
    @body = lead.body
    @photos_link = (lead.photos_enabled) ? "#{root_url}p/#{lead.photos_url_code}" : nil
    @spec_link = "#{root_url}s/#{lead.spec_url_code}"
    @tracking_image_link = "#{root_url}i/#{lead.tracking_image_url_code}"

    status = mail(:to => lead.recipient.email,
         :subject => lead.subject,
         :from => lead.sender.contact.emailField) do |format|
      format.text
      format.html
    end
    
    lead.status = "Sent" if status

  end

end

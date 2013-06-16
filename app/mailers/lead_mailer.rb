class LeadMailer < ActionMailer::Base
  default from: "JetDeck.co <noreply@jetdeck.co>"

  def sendSpec(lead, subject, body)

    @recipient = lead.recipient
    @sender  = lead.sender
    
    status = mail(:to => @recipient.email,
         :subject => subject,
         :body => body,
         :from => @sender.emailField) do |format|
      format.text
      format.html
    end
    
    #xspec.sent = Time.now() if status
    #xspec.save

  end

end

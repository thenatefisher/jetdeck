class XSpecMailer < ActionMailer::Base
  default from: "JetDeck.co <noreply@jetdeck.co>"

  def sendRetail(xspec, recipient)

    @recipient = recipient
    @xspec  = xspec
    @sender  = xspec.sender
    
    status = mail(:to => @recipient.email,
         :subject => xspec.airframe.to_s,
         :from => @sender.emailField) do |format|
      format.text
      format.html
    end
    
    xspec.sent = Time.now() if status
    xspec.save

  end

end

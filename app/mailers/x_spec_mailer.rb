class XSpecMailer < ActionMailer::Base
  default from: "JetDeck.co <noreply@jetdeck.co>"
  layout "retailMailer"

  def sendRetail(xspec, contact)

    @contact = contact
    @url  = xspec.url_code

    status = mail(:to => contact.email,
         :subject => xspec.airframe.to_s) do |format|
      format.html
      format.text
    end
    
    xspec.sent = Time.now() if status
    xspec.save

  end

end

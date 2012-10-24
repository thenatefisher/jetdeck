class ActivationMailer < ActionMailer::Base

    default from: "JetDeck <support@jetdeck.co>"
    
    def activation(recipient)
      @recipient = recipient
      mail  :to => recipient.contact.email, 
            :subject => "Please activate your new JetDeck account."
    end
    
end

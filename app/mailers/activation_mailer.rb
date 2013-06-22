class ActivationMailer < ActionMailer::Base

    default from: "JetDeck <support@jetdeck.co>"
    
    def activation(recipient)
      sendgrid_category "activation"
      sendgrid_unique_args :key2 => "newvalue2", :key3 => "value3"
      @recipient = recipient
      mail  :to => recipient.contact.email, 
            :subject => "Please activate your new JetDeck account."
    end
    
end

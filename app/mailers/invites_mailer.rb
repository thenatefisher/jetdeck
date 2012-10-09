class InvitesMailer < ActionMailer::Base
    default from: "support@jetdeck.co"
    def invite(recipient, sender)
      @recipient = recipient
      @sender = sender
      sender_name = sender.contact.to_s
      mail  :to => recipient.contact.email, 
            :subject => "#{sender_name} Has Invited You to JetDeck!"
    end
end

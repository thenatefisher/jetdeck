class InvitesMailer < ActionMailer::Base
    default from: "JetDeck <support@jetdeck.co>"
    def invite(invite)

      @message    = invite.message
      @name       = invite.name
      @email      = invite.email
      @sender     = invite.sender
      @url        = "#{root_url}signup/#{invite.token}"
      
      mail  :to => @email, 
            :subject => "#{@sender.contact.to_s} Has Invited You to JetDeck!"
    end
end

class UserMailer < ActionMailer::Base
  default from: "JetDeck <support@jetdeck.co>"

  def password_reset(user)
    @user = user
    mail :to => user.contact.email, :subject => "Password Reset"
  end

  def activation(recipient)
    sendgrid_category "activation"
    sendgrid_unique_args :key2 => "newvalue2", :key3 => "value3"
    @recipient = recipient
    mail  :to => recipient.contact.email,
      :subject => "Please activate your new JetDeck account."
  end

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

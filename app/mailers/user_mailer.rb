class UserMailer < ActionMailer::Base
    default from: "JetDeck <support@jetdeck.co>"
    def password_reset(user)
      @user = user
      mail :to => user.contact.email, :subject => "Password Reset"
    end
end

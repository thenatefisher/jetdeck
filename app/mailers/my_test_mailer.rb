class MyTestMailer < ActionMailer::Base
  include SendGrid
  default from: "JetDeck.co <noreply@jetdeck.co>"


  def mailer(to)
    sendgrid_enable :opentrack, :clicktrack
    sendgrid_category "test"
    sendgrid_unique_args :airframe_message_id => "newvalue-#{rand(999)}"

    mail(:to => to,
         :content_type => "text/html",
         :subject => "test subject from console",
         :body => "test body from console")

  end

end

#MyTestMailer::mailer("***REMOVED***").deliver()

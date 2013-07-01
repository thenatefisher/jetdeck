# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

#require "#{Rails.root}/db/seeds/baseline_airframes"
#require "#{Rails.root}/db/seeds/contacts"



contact = Contact.create(
  :first => "Nate",
  :last => "Fisher",
  :email => "***REMOVED***",
  :email_confirmation => "***REMOVED***"
  )

user = User.create({
    :password => "asd123",
    :password_confirmation => "asd123",
    :contact_id => contact.id,
    :activated => true
})

recipient = Contact.create(
    :email => "***REMOVED***",
    :email_confirmation => "***REMOVED***" 
)

airframe = Airframe.create(:creator => user)

airframe_spec = AirframeSpec.create(
    :creator => user,
    :airframe => airframe,
    :spec => File.new("#{Rails.root}/spec/fixtures/f1040.pdf")
)

airframe_message = AirframeMessage.create(
    :subject => "Test Subject",
    :airframe_spec => airframe_spec,
    :airframe => airframe,
    :creator => user,
    :recipient => recipient
)

airframe_message.send_message()
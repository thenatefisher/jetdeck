# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

#require "#{Rails.root}/db/seeds/baseline_airframes"
#require "#{Rails.root}/db/seeds/contacts"



contact = Contact.create(
  :first => "Nate",
  :last => "Fisher",
  :email => "xxx@jetdeck.co",
  :email_confirmation => "xxx@jetdeck.co"
  )

user = User.create({
    :password => "xxx",
    :password_confirmation => "xxx",
    :contact_id => contact.id,
    :activated => true
})

recipient = Contact.create(
    :email => "xxx@gmail.com",
    :email_confirmation => "xxx@gmail.com" 
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
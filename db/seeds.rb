# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

#require "#{Rails.root}/db/seeds/baseline_airframes"
#require "#{Rails.root}/db/seeds/contacts"



Contact.create(
  :first => "Nate",
  :last => "Fisher",
  :email => "***REMOVED***",
  :email_confirmation => "***REMOVED***"
  )

u = User.create()
u.password = "asd123"
u.password_confirmation = "asd123"
u.contact_id = 1
u.save

# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

#require "#{Rails.root}/db/seeds/baseline_airframes"
#require "#{Rails.root}/db/seeds/contacts"

# create 100,000 bogus baseline airframes to test db caching in heroku
100.times do

  airframe = false
  alpha = "abcdefghjklmnpqrstuvwxyz".upcase
  
  begin
    iterator = rand(200) + 50
    registration = "N#{iterator}#{alpha[rand(24)]}#{alpha[rand(24)]}"
    conditions = {:baseline => true, :registration => registration}
    airframe = Airframe.find(:first, :conditions => conditions)
  end while !airframe.blank?
  
  details = {
    :serial => "0000",
    :make => "Fake Mfg",
    :model_name => "Fake Model",
    :year => "2001"
  }
  
  airframe = Airframe.create(conditions.merge(details))
    
end

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

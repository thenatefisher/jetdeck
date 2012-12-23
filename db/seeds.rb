# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

#require "#{Rails.root}/db/seeds/baseline_airframes"
#require "#{Rails.root}/db/seeds/contacts"

# create 100,000 bogus baseline airframes to test db caching in heroku
for i in [1..100000]

  airframe = false
  alpha = "abcdefghjklmnpqrstuvwxyz".upcase
  
  begin
    iterator = rand(200) + 50
    registration = "N#{iterator}#{alpha[rand(24)]}#{alpha[rand(24)]}"
    conditions = {:baseline => true, :registration => registration}
    airframe = Airframe.find(:first, :conditions => conditions)
  while !airframe.blank?
  
  details = {
    :serial => "0000",
    :make => "Fake Mfg",
    :model_name => "Fake Model",
    :year => "2001"
  }
  
  airframe = Airframe.create(conditions.merge(details))
    
end

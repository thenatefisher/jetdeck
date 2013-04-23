# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

#require "#{Rails.root}/db/seeds/baseline_airframes"
#require "#{Rails.root}/db/seeds/contacts"

# create 100,000 bogus baseline airframes to test db caching in heroku
100000.times do

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


fnames = [
"Tom",
"Bill",
"Richard",
"Jerome",
"Martin",
"Steve",
"Phil",
"Alex",
"Susan",
"Margarie",
"Ellen",
"Katie",
"Wynona",
"Mike"]

lnames = [
"Williams",
"Davies",
"Foster",
"Fisher",
"Smith",
"Lawrence",
"Wellers",
"Thompson",
"Loy",
"Fernandez",
"Scott",
"Jeffries"]

companies = [
"Avnet, Inc",
"Republic Services Group",
"IGN Global",
"AT&T Corp",
"Pinnacle West Capital Corporation ",
"First Solar",
"Insight Enterprises",
"Bashas' Supermarkets",
"Universal Technical Institute",
"Fennemore Craig ",
"Ballard Spahr",
"JDA Software Group",
"Leslie's Swimming Pool Supplies",
"Hensley & Co.",
"Desert Schools Federal Credit Union",
"TRRW LLC",
"Go Daddy ",
"Bastion Enterprises"]

titles = [
"Engineer Sr",
"Chief of Medicine",
"Chief Pilot",
"Owner",
"CEO",
"Chief Operating Office",
"Assitant to the VP of Engineering", "Director", "Director of Marketing"]

(0..50).each do |i|

  fname = fnames[rand(fnames.length)]
  lname = lnames[rand(lnames.length)]
  company = companies[rand(companies.length)]
  email = fname.downcase + "." + lname.downcase + "\@" + company.rstrip.lstrip.downcase.split(" ").first + ".com".to_s
  title = titles[rand(titles.length)]

  contact = Contact.create(
    :first => fname,
    :last => lname,
    :source => "",
    :email => email.gsub(/[^@\.a-zA-Z0-9\-]+/,''),
    :company => company,
    :title => title,
    :description => ""
  )

  Address.create(
    #:location => Location.find(rand(LocIdRange).floor+LocIdMin),
    :contact => contact,
    :line1 => (rand(99999)+1000).to_s + " Main St",
    :description => "Home"
  )

  Address.create(
    #:location => Location.find(rand(LocIdRange).floor+LocIdMin),
    :contact => contact,
    :line1 => (rand(99999)+1000).to_s + " Airport Rd",
    :description => "Office"
  )

  if (rand(3) > 1 || User.all.length == 0)
    user = User.create(
    :contact => contact, 
    :password => "123123", 
    :password_confirmation => "123123")
  elsif User.all.length > 0
    UIdMax = User.maximum(:id)
    UIdMin = User.minimum(:id)
    UIdRange = UIdMax - UIdMin
    u = User.find(rand(UIdRange).floor+UIdMin)
    if u 
      u.contact = contact
      u.save
    end
  end

end

if User.all.length > 0
    UIdMax = User.maximum(:id)
    UIdMin = User.minimum(:id)
    UIdRange = UIdMax - UIdMin

    Airframe.all.each do |a|
       a.creator = User.find(rand(UIdRange).floor+UIdMin)
    end
end

# test account
k = User.first.contact
k.email = "test@test.com"
k.email_confirmation = "test@test.com"
k.save

puts "Finished Creating Contact Data"

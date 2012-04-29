puts "Creating Contact Data"

LocIdMax = Location.maximum(:id)
LocIdMin = Location.minimum(:id)
LocIdRange = LocIdMax - LocIdMin

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
    :email => email,
    :company => company,
    :title => title,
    :description => ""
  )

  Address.create(
    :location => Location.find(rand(LocIdRange).floor+LocIdMin),
    :contact => contact,
    :line1 => (rand(99999)+1000).to_s + " Main St",
    :description => "Home"
  )

  Address.create(
    :location => Location.find(rand(LocIdRange).floor+LocIdMin),
    :contact => contact,
    :line1 => (rand(99999)+1000).to_s + " Airport Rd",
    :description => "Office"
  )

  if (rand(3) > 1 || User.all.length == 0)
    user = User.create(:contact => contact)
  else
    UIdMax = User.maximum(:id)
    UIdMin = User.minimum(:id)
    UIdRange = UIdMax - UIdMin
    contact.user = User.find(rand(UIdRange).floor+UIdMin)
    contact.save
  end

end

puts "Finished Creating Contact Data"

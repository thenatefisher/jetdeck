json.(@airframe, :serial)
json.title (@airframe.to_s)

# TODO create model methods for these
json.damage (true)
json.listed (true)
json.tags ([{:name => "April Research", :id => "1"}, {:name => "Previously Held", :id => "1"}])
json.askPrice("$" + number_with_delimiter(12200200))
json.agent({:name => "Steve Muller", :id => "1"})
json.location("On the Moon")
json.spec()
json.leads()
json.location({:icao => "KDVT", :id => "1", :city => "Phoenix, AZ, USA"})


json.model (@airframe.m.name)

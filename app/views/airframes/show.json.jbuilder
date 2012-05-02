json.(@airframe, :totalTime, :totalCycles, :serial, :askingPrice)
json.title (@airframe.to_s)
json.model (@airframe.m.name)
json.engines (@airframe.engines)

# TODO create model methods for these
json.damage (true)
json.listed (true)
json.tags ([{:name => "April Research", :id => "1"}, {:name => "Previously Held", :id => "1"}])
json.location({:icao => "KDVT", :id => "1", :city => "Phoenix, AZ, USA"})




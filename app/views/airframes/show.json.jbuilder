json.(@airframe, :totalTime, :totalCycles, :serial, :askingPrice)

json.title (@airframe.to_s)

json.model (@airframe.m.name)

json.engines @airframe.engines do |json, e|
    json.model e.m
    json.make e.m.make
end

json.equipment @airframe.equipment do |json, i|
    json.model i.modelNumber
    json.label i.abbreviation
    json.name i.name
    json.make i.make.name
end

json.avionics @airframe.avionics do |json, i|
    json.model i.modelNumber
    json.label i.abbreviation
    json.name i.name
    json.make i.make.name
    json.id i.id
end

if (@airframe.airport)
    json.location ({
        :icao => @airframe.airport.icao,
        :city => @airframe.airport.location.city,
        :state => @airframe.airport.location.stateAbbreviation,    
        :id => @airframe.airport.id
    })
end

if (@airframe.creator && @airframe.creator.contact)
    json.agent ({
        :first => @airframe.creator.contact.first,
        :last => @airframe.creator.contact.last,
        :id => @airframe.creator.id
    })
end

# TODO create model methods for these
#json.damage (true)
#json.listed (true)
#json.tags ([{:name => "April Research", :id => "1"}, {:name => "Previously Held", :id => "1"}])


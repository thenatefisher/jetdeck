json.(@airframe, :totalTime, :totalCycles, :serial, :askingPrice)

json.title (@airframe.to_s)

json.model (@airframe.m.name)

json.engines @airframe.engines do |json, e|
    json.model e.m.modelNumber
    json.make e.m.make
    json.label e.label
    json.serial e.serial
    json.totalTime e.totalTime
    json.totalCycles e.totalCycles
    json.shsi e.shsi
    json.smoh e.smoh
    json.tbo e.tbo
    json.hsi e.hsi
    json.year e.year
end

json.equipment @airframe.equipment do |json, i|
    json.model i.modelNumber
    json.label i.abbreviation
    json.name i.name
    json.make i.make.name
    json.type i.etype
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


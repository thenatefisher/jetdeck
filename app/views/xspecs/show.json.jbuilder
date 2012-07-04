json.(@airframe, :totalTime, :registration, :totalCycles, :serial, :askingPrice)

json.title (@airframe.to_s)

json.model (@airframe.m.name)

json.engines @airframe.engines do |json, e|
    json.model (e.m) ? e.m.modelNumber : e.modelName
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

json.avionics @airframe.equipment.where("etype == 'avionics'") do |json, i|
    json.model i.modelNumber
    json.label i.abbreviation
    json.name i.name
    json.make i.make.name
    json.type i.etype
    json.id i.id
end

json.equipment @airframe.equipment.where("etype != 'avionics' AND etype != 'engines'") do |json, i|
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
    if (@airframe.creator.contact.first &&
        @airframe.creator.contact.last)
        json.agentName @airframe.creator.contact.first + " " + @airframe.creator.contact.last
    else
      json.agentName ""
    end
    json.agentPhone @airframe.creator.contact.phone
    json.agentWebsite @airframe.creator.contact.website
    json.agentCompany @airframe.creator.contact.company
    json.agentEmail @airframe.creator.contact.email
end

json.recipient @spec.recipient.email

json.(@spec, :message, :salutation, :show, :headline1, :headline2, :headline3)

json.images @airframe.accessories do |json, i|
    json.preview "http://s3.amazonaws.com/jetdeck/images/#{i.id}/spec_monitor/#{i.image_file_name}" if i.image_file_name
    json.original "http://s3.amazonaws.com/jetdeck/images/#{i.id}/original/#{i.image_file_name}" if i.image_file_name
    json.thumbnail i.thumbnail
end

# TODO create model methods for these
#json.damage (true)
#json.listed (true)
#json.tags ([{:name => "April Research", :id => "1"}, {:name => "Previously Held", :id => "1"}])

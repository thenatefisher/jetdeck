json.(@airframe, :id, :avatar, :tt, :tc, :serial, :askingPrice, :registration, :make, :modelName, :year)

json.title (@airframe.to_s)

json.model (@airframe.modelName)

json.engines @airframe.engines do |json, e|
    json.id e.id
    json.modelName e.modelName
    json.make e.make
    json.name e.name
    json.serial e.serial
    json.ttsn e.ttsn
    json.tcsn e.tcsn
    json.shsi e.shsi
    json.smoh e.smoh
    json.tbo e.tbo
    json.hsi e.hsi
    json.year e.year
end

json.equipment @airframe.equipment do |json, i|
    json.name i.name
    json.title i.title
    json.etype i.etype
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

json.leads @airframe.xspecs do |json, x|

    json.id x.recipient.id

    json.email x.recipient.email

    if x.recipient.first && x.recipient.last
      json.name x.recipient.first + " " + x.recipient.last
    end

    if x.recipient.company
      json.company x.recipient.company
    end

    json.hits x.hits

    json.recipient_id x.recipient.id

    if x.hits > 0
        json.last_viewed x.views.last.created_at
    else
        json.last_viewed ""
    end

    json.fire x.fire || false

    json.url "/s/" + x.urlCode
    
    json.xspecId x.id

end

# TODO create model methods for these
#json.damage (true)
#json.listed (true)
#json.tags ([{:name => "April Research", :id => "1"}, {:name => "Previously Held", :id => "1"}])

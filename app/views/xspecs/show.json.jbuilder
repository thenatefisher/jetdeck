json.(@airframe, :tt, :registration, :model_name, :tc, :serial, :asking_price)

json.engines @airframe.engines do |json, e|
    json.model_name e.model_name
    json.label e.label
    json.serial e.serial
    json.tt e.tt
    json.tc e.tc
    json.shsi e.shsi
    json.smoh e.smoh
    json.tbo e.tbo
    json.hsi e.hsi
    json.year e.year
end

json.avionics @airframe.equipment.where("etype = 'avionics'") do |json, i|
    json.model i.name
    json.title i.title
    json.id i.id
end

json.equipment @airframe.equipment.where("etype != 'avionics') do |json, i|
    json.model i.name
    json.title i.title
    json.etype i.etype
    json.id i.id
end

if (@airframe.airport)
    json.location ({
        :icao => @airframe.airport.icao,
        :city => @airframe.airport.location.city,
        :state => @airframe.airport.location.state_abbreviation,
        :id => @airframe.airport.id
    })
end

if (@airframe.creator && @airframe.creator.contact)
    if (@airframe.creator.contact.first &&
        @airframe.creator.contact.last)
        json.agent_name @airframe.creator.contact.first + " " + @airframe.creator.contact.last
    else
      json.agent_name ""
    end
    json.agent_phone @airframe.creator.contact.phone
    json.agent_website @airframe.creator.contact.website
    json.agent_company @airframe.creator.contact.company
    json.agent_email @airframe.creator.contact.email
end

json.recipient @xspec.recipient.email

json.(@xspec, :message, :salutation, :show_message, :headline1, :headline2, :headline3)

json.images @airframe.accessories do |json, i|
    json.preview "http://s3.amazonaws.com/jetdeck/images/#{i.id}/spec_monitor/#{i.image_file_name}" if i.image_file_name
    json.original "http://s3.amazonaws.com/jetdeck/images/#{i.id}/original/#{i.image_file_name}" if i.image_file_name
    json.thumbnail i.thumbnail
end


json.(@airframe, 
  :id, 
  :avatar, 
  :tt, 
  :tc, 
  :make, 
  :model_name, 
  :year
)

if @xspec.override_description.present?
  json.description @xspec.override_description 
else
  json.description @airframe.description 
end

if @xspec.override_price.present?
  asking_price = @xspec.override_price 
else
  asking_price =  number_to_currency @airframe.asking_price, :precision => 0 
end

json.asking_price (!@xspec.hide_price) ? asking_price : nil

json.serial (!@xspec.hide_serial) ? @airframe.serial : nil

json.registration (!@xspec.hide_registration) ? @airframe.registration : nil

json.location @airframe.airport.location if @airframe.airport && !@xspec.hide_location

json.background @xspec.background if @xspec.background

json.engines @airframe.engines do |json, e|
    json.id e.id
    json.model_name e.model_name
    json.make e.make
    json.name e.name
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
    json.name i.name
    json.title i.title
    json.id i.id
end

json.equipment @airframe.equipment.where("etype != 'avionics'") do |json, i|
    json.name i.name
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
    if @airframe.creator.logo
      json.logo @airframe.creator.logo.url  
    end    
end

json.recipient @xspec.recipient.email

json.(@xspec, :url_code, :message, :salutation, :show_message, :headline1, :headline2, :headline3)

json.images @airframe.accessories do |json, i|
    json.preview "http://s3.amazonaws.com/jetdeck/images/#{i.id}/spec_monitor/#{i.image_file_name}" if i.image_file_name
    json.original "http://s3.amazonaws.com/jetdeck/images/#{i.id}/original/#{i.image_file_name}" if i.image_file_name
    json.thumbnail i.thumbnail
    json.spec_lightbox "http://s3.amazonaws.com/jetdeck/images/#{i.id}/spec_lightbox/#{i.image_file_name}" if i.image_file_name
end


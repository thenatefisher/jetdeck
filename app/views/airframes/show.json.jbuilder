json.(@airframe, 
  :id, 
  :avatar, 
  :tt, 
  :tc, 
  :serial, 
  :asking_price, 
  :registration, 
  :make, 
  :model_name, 
  :year,
  :description
)

json.title (@airframe.to_s)

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
        :state => @airframe.airport.location.state_abbreviation,
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

    if x.recipient.present?
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

        if x.hits > 0 && x.views
            json.last_viewed x.views.last.created_at
        else
            json.last_viewed ""
        end

        json.fire x.fire || false

        json.url "/s/" + x.url_code
        
        json.xspec_id x.id
        
        json.recipientEmailField x.recipient.emailField
        
    end
    
end

json.notes @airframe.notes do |json, x|
  json.title x.title
  json.description x.description  
  json.id x.id
  json.created_at x.created_at
end

json.actions @airframe.actions do |json, c|
    json.id c.id
    json.title c.title
    json.description c.description
    json.due_at c.due_at
    json.is_completed c.is_completed
    json.completed_at c.completed_at
    json.type c.actionable_type
    json.url c.url
    json.list_due_at c.due_at.strftime("%b %d, %Y") if c.due_at
    json.list_title c.title.truncate(35) if c.title
    json.past_due (c.due_at < Time.now()) if c.due_at    
end

# TODO create model methods for these
#json.damage (true)
#json.listed (true)
#json.tags ([{:name => "April Research", :id => "1"}, {:name => "Previously Held", :id => "1"}])

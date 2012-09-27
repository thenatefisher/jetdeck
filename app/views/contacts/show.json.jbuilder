json.(@contact, 
  :company, 
  :email, 
  :first, 
  :last, 
  :phone,
  :id
)

json.notes @contact.notes do |json, x|
  json.title x.title
  json.description x.description  
  json.id x.id
  json.created_at x.created_at
end

json.actions @contact.actions do |json, c|
    json.id c.id
    json.title c.title
    json.description c.description
    json.due_at c.due_at
    json.is_completed c.is_completed
    json.completed_at c.completed_at
    json.type c.actionable_type
    json.url c.url
end

json.specs @contact.specsReceived do |json, x|

        json.hits x.hits

        if x.hits > 0 && x.views
            json.last_viewed x.views.last.created_at
        else
            json.last_viewed ""
        end

        json.fire x.fire || false

        json.url "/s/" + x.url_code
        
        if x.airframe
        
          json.id             x.airframe.id
          json.registration   x.airframe.registration
          json.serial         x.airframe.serial
          json.year           x.airframe.year
          json.make           x.airframe.make
          json.model_name     x.airframe.model_name
          json.avatar         x.airframe.avatar
          
        end

end


json.(@contact, 
  :company, 
  :email, 
  :first, 
  :last, 
  :phone
)

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


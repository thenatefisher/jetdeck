json.(@contact, 
  :company, 
  :email, 
  :first, 
  :last, 
  :phone,
  :id
)

json.ownerships @contact.ownerships do |json, x|
  json.description x.description  
  json.assoc x.assoc  
  json.id x.id
end

json.notes @contact.notes do |json, x|
  json.title x.title
  json.description x.description  
  json.id x.id
  json.created_at x.created_at.localtime if x.created_at
  json.type x.notable_type
  json.parent_name x.notable.to_s
  json.author x.author.contact.fullName if x.author
  json.date x.created_at.localtime.strftime("%a, %b %e")
  json.time x.created_at.localtime.strftime("%l:%M%P %Z")
  json.is_mine true if @current_user and (@current_user.id == x.created_by)
end

json.actions @contact.actions do |json, c|
    json.id c.id
    json.title c.title
    json.description c.description
    json.due_at c.due_at.localtime if c.due_at
    json.is_completed c.is_completed
    json.completed_at c.completed_at.localtime if c.completed_at
    json.type c.actionable_type
    json.url c.url
    json.created_at c.created_at.localtime if c.created_at
    json.parent_name c.actionable.to_s
    json.list_due_at c.due_at.localtime.strftime("%b %d, %Y") if c.due_at
    json.list_title c.title.truncate(35) if c.title
    json.past_due (c.due_at < Time.now()) if c.due_at   
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


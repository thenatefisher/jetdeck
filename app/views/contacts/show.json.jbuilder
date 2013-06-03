json.company h @contact.company
json.email h @contact.email
json.first h @contact.first
json.last h @contact.last
json.phone h @contact.phone
json.id @contact.id
json.sticky_id @contact.sticky_id

json.ownerships @contact.ownerships do |json, x|
  json.description h x.description  
  json.assoc h x.assoc  
  json.id x.id
end

json.notes @contact.notes do |json, x|
  json.title h x.title
  json.description h x.description  
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
    json.title h c.title
    json.description h c.description
    json.due_at c.due_at.localtime if c.due_at
    json.is_completed c.is_completed
    json.completed_at c.completed_at.localtime if c.completed_at
    json.type c.actionable_type
    json.url c.url
    json.created_at c.created_at.localtime if c.created_at
    json.parent_name c.actionable.to_s
    json.list_due_at c.due_at.localtime.strftime("%b %d, %Y") if c.due_at
    json.list_title h c.title.truncate(35) if c.title
    json.past_due (c.due_at < Time.now()) if c.due_at   
end

json.specs @contact.files_received do |json, x|

    if x.spec

        json.photos_url_code "/s/" + x.photos_url_code
        json.spec_url_code "/s/" + x.spec_url_code
        
        json.status x.status
        json.status_date x.status_date
        
        json.spec "#{x.spec.document_file_name} (#{x.spec.version.upcase})"

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

end


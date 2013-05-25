json.id @airframe.id
json.avatar @airframe.avatar
json.tt h @airframe.tt
json.tc h @airframe.tc
json.serial h @airframe.serial
json.asking_price h @airframe.asking_price
json.registration h @airframe.registration
json.make h @airframe.make
json.model_name h @airframe.model_name
json.year h @airframe.year
json.description h @airframe.description
json.import_url h @airframe.import_url

json.title h(@airframe.to_s)

json.engines @airframe.engines do |json, e|
    json.id e.id
    json.model_name h e.model_name
    json.make h e.make
    json.name h e.name
    json.serial h e.serial
    json.tt h e.tt
    json.tc h e.tc
    json.shsi h e.shsi
    json.smoh h e.smoh
    json.tbo h e.tbo
    json.hsi h e.hsi
    json.year h e.year
end

json.airframe_texts @airframe.airframe_texts do |json, i|
    json.body h i.body
    json.label h i.label
    json.id i.id
end

json.equipment @airframe.equipment do |json, i|
    json.name h i.name
    json.title h i.title
    json.etype i.etype
    json.id i.id
end

json.location @airframe.location do |json, i|
    json.city h i.city
    json.state h i.state_abbreviation
end

if (@airframe.creator && @airframe.creator.contact)
    json.agent ({
        :first => @airframe.creator.contact.first,
        :last => @airframe.creator.contact.last,
        :id => @airframe.creator.id
    })
end

views = Array.new
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

        views += x.views
        
    end
    
end

activity = Array.new()
now = Time.now()
(1..14).each do |day_number|

    start_date = now - day_number.day
    end_date = now - (day_number-1).day

    count = 0
    views.each {|v| count += 1 if v.created_at < end_date and v.created_at > start_date}
    activity << count

end
json.activity activity.reverse

json.notes @airframe.notes do |json, x|
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

json.actions @airframe.actions do |json, c|
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

# TODO create model methods for these
#json.damage (true)
#json.listed (true)
#json.tags ([{:name => "April Research", :id => "1"}, {:name => "Previously Held", :id => "1"}])

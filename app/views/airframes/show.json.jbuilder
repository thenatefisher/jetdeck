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

if (@airframe.creator && @airframe.creator.contact)
    json.agent ({
        :first => @airframe.creator.contact.first,
        :last => @airframe.creator.contact.last,
        :id => @airframe.creator.id
    })
end


json.leads @airframe.leads do |json, x|

    if x.recipient.present? && x.spec

        json.id x.recipient.id

        json.email x.recipient.email

        if x.recipient.first && x.recipient.last
          json.name x.recipient.first + " " + x.recipient.last
        end

        if x.recipient.company
          json.company x.recipient.company
        end

        json.recipient_id x.recipient.id

        json.recipientEmailField x.recipient.emailField

        json.photos_url_code "/s/" + x.photos_url_code
        json.spec_url_code "/s/" + x.spec_url_code
        
        json.status x.status
        json.status_date x.status_date
        
        json.spec "#{x.spec.document_file_name} (#{x.spec.version.upcase})"

    end
    
end

json.specs @airframe.specs do |json, x|
    json.file_name x.document_file_name
    json.version x.version
    json.created_at x.created_at
    json.enabled x.enabled
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

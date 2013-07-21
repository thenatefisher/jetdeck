json.id @airframe.id
json.serial h @airframe.serial
json.asking_price h @airframe.asking_price
json.registration h @airframe.registration
json.make h @airframe.make
json.model_name h @airframe.model_name
json.year h @airframe.year
json.description h @airframe.description
json.import_url h @airframe.import_url
json.to_s h(@airframe.to_s)
json.long h(@airframe.long)

json.avatar @airframe.avatar[:thumb] if @airframe.avatar.present?

json.leads @airframe.leads do |x|
    json.id x.id
    json.contact_label x.contact.to_s
    json.spec_label x.contact.messages_received.where(:airframe_id => @airframe.id).last.airframe_spec.spec_file_name rescue nil
    json.spec_url x.contact.messages_received.where(:airframe_id => @airframe.id).last.airframe_spec.url rescue nil
    json.status_label x.contact.messages_received.where(:airframe_id => @airframe.id).last.status rescue nil
    json.status_date_label x.contact.messages_received.where(:airframe_id => @airframe.id).last.status_date.localtime.strftime("%b %d, %Y") rescue nil
    json.status_time_label x.contact.messages_received.where(:airframe_id => @airframe.id).last.status_date.localtime.strftime("%H:%M %p") rescue nil
    json.photos_enabled x.contact.messages_received.where(:airframe_id => @airframe.id).last.photos_enabled rescue nil    
    json.contact x.contact
    json.messages x.contact.messages_received.where(:airframe_id => @airframe.id) do |m|
        json.id m.id
        json.created_at m.created_at
        json.status m.status
        json.status_date m.status_date
        json.status_date_label m.status_date.localtime.strftime("%b %d, %Y") rescue nil
        json.status_time_label m.status_date.localtime.strftime("%H:%M %p") rescue nil
        json.photos_enabled m.photos_enabled
        json.spec_url m.airframe_spec.url
        json.spec_file_name m.airframe_spec.spec_file_name
        json.spec_enabled m.spec_enabled
    end
end

json.specs @airframe.specs do |x|
    json.file_name x.spec_file_name
    json.created_at x.created_at
    json.enabled x.enabled
    json.link x.url
    json.id x.id
end

json.images @airframe.images do |x|
    json.delete_type "DELETE"
    json.delete_url "/airframe_images/#{x.id}"
    json.id x.id
    json.name x.image_file_name
    json.size x.image_file_size
    json.thumbnail_url x.url("mini")
    json.url x.url("original", 1.day)
    json.thumbnail x.thumbnail
end

json.todos @airframe.todos do |c|
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

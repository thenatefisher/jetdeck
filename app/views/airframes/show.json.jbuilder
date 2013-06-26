json.id @airframe.id
json.avatar @airframe.avatar
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

json.leads @airframe.leads do |x|
    json.contact x.contact
end

json.specs @airframe.specs do |x|
    json.file_name x.spec_file_name
    json.created_at x.created_at
    json.enabled x.enabled
    json.link x.url
    json.id x.id
    json.airframe_messages x.airframe_messages
end

json.actions @airframe.todos do |c|
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

json.array! @actions do |json, c|
    json.id c.id
    json.title c.title
    json.description c.description
    json.due_at c.due_at
    json.is_completed c.is_completed
    json.completed_at c.completed_at
    json.type c.actionable_type
    json.url c.url
    json.parent_name c.actionable.to_s
    json.list_due_at c.due_at.strftime("%b %d, %Y") if c.due_at
    json.list_title c.title.truncate(35) if c.title
    json.past_due (c.due_at < Time.now()) if c.due_at    
end

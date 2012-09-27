json.array! @actions do |json, c|
    json.id c.id
    json.title c.title
    json.description c.description
    json.due_at c.due_at
    json.is_completed c.is_completed
    json.completed_at c.completed_at
    json.type c.actionable_type
    json.url c.url
end

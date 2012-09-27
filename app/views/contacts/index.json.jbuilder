json.array! @contacts do |json, c|
    json.id c.id
    json.company c.company
    json.first c.first
    json.last c.last
    json.email c.email
end

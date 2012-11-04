json.array! @contacts do |json, c|
    json.id c.id
    json.company h c.company
    json.first h c.first
    json.last h c.last
    json.email h c.email
end

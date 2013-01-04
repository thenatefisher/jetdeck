json.array! @contacts do |json, a|
    json.label h (a.to_s)
    json.id a.id
    json.value h a.email
end

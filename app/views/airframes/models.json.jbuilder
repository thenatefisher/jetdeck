json.array! @airframes do |json, a|
    json.text a.m.make.name + " " + a.m.name
    json.id a.m.id
end

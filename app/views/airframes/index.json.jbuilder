json.array! @airframes do |json, a|
    json.id a.id
    json.to_s truncate(h(a.to_s), :length => 26)
    json.serial h a.serial
    json.registration h a.registration
    json.year h a.year
    json.tt h a.tt
    json.tc h a.tc
    json.location a.airport
    json.created_at a.created_at
    json.avatar a.avatar
end

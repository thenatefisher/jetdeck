json.array! @airframes do |json, a|
    json.id a.id
    json.to_s a.to_s
    json.serial a.serial
    json.registration a.registration
    json.year a.year
    json.tt a.tt
    json.tc a.tc
    json.location a.airport
    json.created_at a.created_at
    json.avatar a.avatar
end

json.array! @airframes do |a|
    json.id a.id
    json.to_s h(a.to_s)
    json.long h(a.long)
    json.serial h a.serial
    json.registration h a.registration
    json.year h a.year
    json.created_at a.created_at
    json.avatar a.avatar
end

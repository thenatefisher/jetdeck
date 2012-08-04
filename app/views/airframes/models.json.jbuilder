json.array! @airframes do |json, a|
    json.text a.make + " " + a.model_name
    json.id a.id
end

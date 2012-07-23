json.array! @airframes do |json, a|
    json.text a.make + " " + a.modelName
    json.id a.id
end

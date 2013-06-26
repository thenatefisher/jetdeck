json.array! @airframes do |a|
    json.text h (a.make + " " + a.model_name)
    json.id a.id
end

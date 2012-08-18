json.array!(@engines) do |json, e|
    json.id e.id
    json.make e.make if e.make
    json.model e.model_name
    json.text e.model_name + " (" + e.make + ")"
    json.tbo e.tbo || ''
    json.hsi e.hsi || ''
end


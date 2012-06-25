json.array!(@engines) do |json, e|
    json.make e.m.name if e.m.present?
    json.model e.m.modelNumber if e.m.present?  
    json.id e.id
end


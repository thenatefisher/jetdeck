json.array!(@equipment) do |json, e|
    json.make e.make.name if e.make != nil
    json.model e.modelNumber
    json.label e.abbreviation    
    json.id e.id
    json.type e.etype
end


json.interiors @interiors do |json, e|
    json.make e.make.name if e.make != nil
    json.model e.modelNumber
    json.label e.abbreviation    
    json.id e.id
end

json.exteriors @exteriors do |json, e|
    json.make e.make.name if e.make != nil
    json.model e.modelNumber
    json.label e.abbreviation 
    json.id e.id   
end

json.equipment @equipment do |json, e|
    json.make e.make.name if e.make != nil
    json.model e.modelNumber
    json.label e.abbreviation    
    json.id e.id
end

json.avionics @avionics do |json, e|
    json.make e.make.name if e.make != nil
    json.model e.modelNumber
    json.label e.abbreviation    
    json.id e.id
end


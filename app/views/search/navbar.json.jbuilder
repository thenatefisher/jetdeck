json.array! @results do |json, a|
    json.url a.search_url
    json.label a.search_label
    json.desc a.search_desc
end

json.(@lead, 
  :id,
  :photos_url_code, 
  :spec_url_code, 
  :recipient,
  :airframe,
  :spec,
  :status_date,
  :body,
  :subject,
  :photos_enabled,
  :spec_enabled,
  :created_at
)

json.status @lead.status

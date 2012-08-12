json.(@xspec, 
  :id,
  :message, 
  :salutation, 
  :show_message, 
  :headline1, 
  :headline2, 
  :headline3,
  :override_description,
  :override_price,
  :hide_price,
  :hide_registration, 
  :hide_serial, 
  :hide_location,
  :background_id,
  :sent
)

json.created_at @xspec.created_at.strftime("%b %e (%l:%M%p %Z)") 

json.history @xspec.history

json.backgrounds @backgrounds do |json, b|
  json.url b.url
  json.thumbnail b.thumbnail
end

json.sent @xspec.sent.strftime("%b %e (%l:%M%p %Z)") if @xspec.sent

if @xspec.override_price.present?
  json.displayed_price @xspec.override_price 
else
  json.displayed_price number_to_currency @xspec.airframe.asking_price, :precision => 0 
end

json.asking_price number_to_currency @xspec.airframe.asking_price, :precision => 0 

json.recipient @xspec.recipient.email

json.hits @xspec.hits

if @xspec.hits > 0 && @xspec.views.last
    json.last_viewed @xspec.views.last.created_at.strftime("%b %e (%l:%M%p %Z)") 
else
    json.last_viewed ""
end

json.top_average @xspec.top_average


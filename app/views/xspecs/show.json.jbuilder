json.(@xspec, 
  :id,
  :url_code, 
  :message, 
  :sent
)

json.created_at @xspec.created_at.strftime("%b %e (%l:%M%p %Z)") 

json.history @xspec.history

json.sent @xspec.sent.strftime("%b %e (%l:%M%p %Z)") if @xspec.sent

json.asking_price number_to_currency @xspec.airframe.asking_price, :precision => 0 

json.recipient @xspec.recipient

json.hits @xspec.hits

if @xspec.hits > 0 && @xspec.views.last
    json.last_viewed @xspec.views.last.created_at.strftime("%b %e (%l:%M%p %Z)") 
else
    json.last_viewed ""
end

json.top_average @xspec.top_average


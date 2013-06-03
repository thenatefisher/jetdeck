json.(@user, :id)

json.contact (@user.contact)

json.airframes @user.airframes.count
json.contacts @user.contacts.count

json.sent @user.airframes.reduce(0) { |s,v| s += v.leads.count }

json.signature h @user.signature

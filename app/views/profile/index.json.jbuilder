json.(@user, :id, :activated, :storage_usage, :storage_quota)
json.contact (@user.contact)
json.airframes @user.airframes.count
json.contacts @user.contacts.count
json.leads @user.airframes.reduce(0) { |s,v| s += v.leads.count }
json.signature h @user.signature

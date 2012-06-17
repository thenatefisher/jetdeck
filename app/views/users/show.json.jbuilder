json.(@user, :id)

json.contact (@user.contact)

json.airframes @user.airframes.count
json.contacts rand(1..100)
json.sent rand(1..100)
json.views rand(1..100)

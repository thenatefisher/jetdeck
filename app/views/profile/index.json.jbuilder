json.(@user, :id)

json.contact (@user.contact)

json.airframes @user.airframes.count
json.contacts @user.contacts.count

@totalSent = 0
@user.airframes.each { |a| @totalSent += a.xspecs.count }
json.sent @totalSent

@totalViews = 0
@user.airframes.each do |a|
    a.xspecs.each { |x| @totalViews += x.views.count }
end
json.views @totalViews

json.spec_disclaimer h @user.spec_disclaimer

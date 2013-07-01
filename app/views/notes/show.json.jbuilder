json.(@note,
    :id,
    :title,
    :description)

json.created_at @note.created_at.localtime if @note.created_at
json.type @note.notable_type
json.parent_name @note.notable.to_s
json.author @note.author.contact.fullName if @note.author
json.date @note.created_at.localtime.strftime("%a, %b %e")
json.time @note.created_at.localtime.strftime("%l:%M%P %Z")
json.is_mine true if @current_user and (@current_user.id == @note.created_by)

json.(@airframe, 
  :id, 
  :avatar, 
  :tt, 
  :tc, 
  :make, 
  :model_name, 
  :year
)

json.airframe_texts @airframe.airframe_texts do |i|
    json.body i.body
    json.label i.label
    json.id i.id
end

json.asking_price (!@xspec.hide_price) ? asking_price : nil

json.serial (!@xspec.hide_serial) ? @airframe.serial : nil

json.registration (!@xspec.hide_registration) ? @airframe.registration : nil

if (@airframe.creator && @airframe.creator.contact)
    if (@airframe.creator.contact.first &&
        @airframe.creator.contact.last)
        json.agent_name @airframe.creator.contact.first + " " + @airframe.creator.contact.last
    else
      json.agent_name ""
    end
    if @airframe.creator.contact.first
      json.agent_first h @airframe.creator.contact.first 
    end
    json.agent_phone h @airframe.creator.contact.phone
    json.agent_website h @airframe.creator.contact.website
    json.agent_company h @airframe.creator.contact.company
    json.agent_email h @airframe.creator.contact.email  
    json.spec_disclaimer @airframe.creator.spec_disclaimer
end

json.recipient @xspec.recipient.email

json.(@xspec, :url_code, :message)

json.images @airframe.accessories do |json, i|
    json.original "http://s3.amazonaws.com/" + Jetdeck::Application.config.aws_s3_bucket + "/images/#{i.id}/original/#{i.image_file_name}" if i.image_file_name
    json.thumbnail i.thumbnail
    json.slides "http://s3.amazonaws.com/" + Jetdeck::Application.config.aws_s3_bucket + "/images/#{i.id}/slides/#{i.image_file_name}" if i.image_file_name
end



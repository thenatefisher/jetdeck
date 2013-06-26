json.array! @airframes do |airframe|

  label = airframe.serial
  if airframe.registration.present? && airframe.serial.present?
    label += " (#{airframe.registration.upcase})"
  else
    label = airframe.registration.upcase
  end

  label = "<i class=\"icon-plane\"></i> #{label}"

  json.search_url "/airframes/#{airframe.id}"
  json.search_desc airframe.to_s
  json.search_label label

end
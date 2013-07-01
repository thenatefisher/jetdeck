json.array! @results do |result|

  if (result.class == Airframe)

      label = result.serial
      if result.registration.present? && result.serial.present?
        label += " (#{result.registration.upcase})"
      else
        label = result.registration.upcase
      end

      label = "<i class=\"icon-plane\"></i> #{label}"

      json.url "/airframes/#{result.id}"
      json.desc result.to_s
      json.label label

  else

      json.url "/contacts/#{result.id}"
      json.desc result.company
      json.label "<i class=\"icon-user\"></i> #{result.fullName}"

  end

end
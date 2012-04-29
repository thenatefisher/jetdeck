# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

#engines (serial number) <--> equipment (part number) <--> equipment_detail
#airframes (serial number) <--> airframe_equipment <--> equipment (part number) <--> equipment_detail

#require "#{Rails.root}/db/seeds/baseline_airframes"
#require "#{Rails.root}/db/seeds/locations"
#require "#{Rails.root}/db/seeds/contacts"
#require "#{Rails.root}/db/seeds/airports"

require "#{Rails.root}/db/seeds/engines"
# airframes
# airframe_contacts
# specs
# spec_views
# spec_permissions

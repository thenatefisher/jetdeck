class AirframeEquipment < ActiveRecord::Base

  belongs_to :airframe
  belongs_to :equipment

end

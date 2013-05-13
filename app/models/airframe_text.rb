class AirframeText < ActiveRecord::Base
  attr_accessible :airframe_id, :body, :label
  belongs_to :airframe
end

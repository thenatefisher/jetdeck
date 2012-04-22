class AirframeHistory < ActiveRecord::Base
  belongs_to :user
  belongs_to :airframe
end

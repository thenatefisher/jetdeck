# == Schema Information
# Schema version: 20120429080558
#
# Table name: airframe_equipments
#
#  id           :integer         not null, primary key
#  airframe_id  :integer
#  equipment_id :integer
#  user_id      :integer
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  engine_id    :integer
#

class AirframeEquipment < ActiveRecord::Base

  belongs_to :airframe
  belongs_to :equipment
  belongs_to :engine

end

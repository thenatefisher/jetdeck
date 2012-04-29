# == Schema Information
# Schema version: 20120429080558
#
# Table name: equipment_details
#
#  id                   :integer         not null, primary key
#  value                :string(255)
#  parameter            :string(255)
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#  airframeEquipment_id :integer
#

class EquipmentDetail < ActiveRecord::Base
  belongs_to :equipment
end

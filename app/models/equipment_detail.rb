# == Schema Information
# Schema version: 20120427044143
#
# Table name: equipment_details
#
#  id           :integer         not null, primary key
#  equipment_id :integer
#  value        :string(255)
#  parameter    :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

class EquipmentDetail < ActiveRecord::Base
  belongs_to :equipment
end

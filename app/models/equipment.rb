# == Schema Information
# Schema version: 20120427044143
#
# Table name: equipment
#
#  id              :integer         not null, primary key
#  manufacturer_id :integer         indexed
#  abbreviation    :string(255)
#  modelNumber     :string(255)
#  name            :string(255)
#  description     :text
#  etype           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  serial          :string(255)
#

class Equipment < ActiveRecord::Base

  belongs_to  :make,
              :foreign_key => 'manufacturer_id',
              :class_name => 'Manufacturer'
  has_many :airframes, :foreign_key => 'model_id'
  has_many :airframe_equipments
  has_many :airframes, :through => :airframe_equipments
  has_many :equipment_details

  def self.eTypes
    types = [ "avionics",
              "engines",
              "interiors",
              "exteriors",
              "modifications",
              "equipment"]
  end


end

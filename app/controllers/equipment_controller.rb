class EquipmentController < ApplicationController
  # GET /equipment
  # GET /equipment.json
  def index
    @equipment = Equipment.where("etype = 'equipment' OR etype = 'modifications'")
    @avionics = Equipment.where(:etype=>"avionics")
    @interiors = Equipment.where(:etype=>"interiors")
    @exteriors = Equipment.where(:etype=>"exteriors")
  end
end

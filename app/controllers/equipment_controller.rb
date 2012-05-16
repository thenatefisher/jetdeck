class EquipmentController < ApplicationController
  # GET /equipment
  # GET /equipment.json
  def index
    @equipment = Equipment.all
  end
end

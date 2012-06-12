class EquipmentController < ApplicationController
  before_filter :authorize

  # GET /equipment
  # GET /equipment.json
  def index
    @equipment = Equipment.all
  end
end

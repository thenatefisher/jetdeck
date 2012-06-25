class EquipmentController < ApplicationController
  before_filter :authorize

  # GET /equipment
  # GET /equipment.json
  def index
    @equipment = Equipment.all
  end
  
  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @equipment = Equipment.find(params[:id])
    @equipment.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
    
end

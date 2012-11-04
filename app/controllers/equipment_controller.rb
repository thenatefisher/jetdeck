class EquipmentController < ApplicationController
  
  before_filter :authorize, :sanitize_params

  # DELETE /Equipment/1
  # DELETE /Equipment/1.json
  def destroy
    @equipment = Equipment.find(params[:id])
    if @equipment.airframe.creator == @current_user
      @equipment.destroy
    end
    
    respond_to do |format|
      format.json { head :no_content }
    end
  end
 
end

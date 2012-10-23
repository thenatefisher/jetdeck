class DetailsController < ApplicationController
  before_filter :authorize

  def destroy
    @d = Detail.find(params[:id])
    if @d.detailable.owner == @current_user
      @d.destroy
    end
    
    respond_to do |format|
      format.json { head :no_content }
    end
  end
 
end

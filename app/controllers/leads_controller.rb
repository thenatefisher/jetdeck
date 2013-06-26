class LeadsController < ApplicationController
  before_filter :authorize, :sanitize_params

  def create
    
    
  end

  def destroy
    
    @xspec = Lead.where("id = ? AND sender_id = ?", params[:id], @current_user.id).first
    
    if @xspec
       @xspec.destroy()
    end
    
    respond_to do |format|
      format.json { head :no_content }
    end
    
  end
  
end

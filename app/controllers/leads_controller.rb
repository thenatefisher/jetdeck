class LeadsController < ApplicationController
  before_filter :authorize, :sanitize_params

  def create
    
    
  end

  def destroy
    
    @Lead = Lead.where("id = ? AND sender_id = ?", params[:id], @current_user.id).first
    
    if @Lead
       @Lead.destroy()
       render :json => "OK", :status => :ok
    else
       render :json => ["You do have have permissions to delete this lead."], :status => :unprocessable_entity
    end

  end
  
end

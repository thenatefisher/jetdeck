class EnginesController < ApplicationController
  before_filter :authorize

  # GET /engines
  # GET /engines.json
  def index
    @engines = Engine.where("baseline = 't' OR user_id = '?'", @current_user.id).group(:model_name)
  end
  
  # PUT /engines/1
  # PUT /engines/1.json
  def update
    @engine = Engine.find(:first, :conditions => ["id = ? AND user_id = ?", params[:id], @current_user.id])
    whitelist = Hash.new
    whitelist = params[:engine].slice(:year, :make, :model_name, :serial, :smoh, :shsi, :hsi, :tbo, :tt, :tc, :name)

    respond_to do |format|
      if @engine.update_attributes(whitelist)
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @engine.errors, :status => :unprocessable_entity }
      end
    end
  end  
  
  # DELETE /engines/1
  # DELETE /engines/1.json
  def destroy
    @engine = Engine.find(:first, :conditions => ["id = ? AND user_id = ?", params[:id], @current_user.id])
    @engine.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
 
end

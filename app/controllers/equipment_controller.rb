class EquipmentController < ApplicationController
  before_filter :authorize

  # GET /Equipment
  # GET /Equipment.json
  def index
    #@equipment = Equipment.where("user_id = '?' && airframe_id = '?'", @current_user.id, params[:airframe_id])
  end
  
  # PUT /Equipment/1
  # PUT /Equipment/1.json
  def update
    @equipment = Equipment.find(params[:id])
    whitelist = Hash.new()
    if @equipment.airframe && @equipment.airframe.creator == @current_user
      whitelist = params[:equipment].slice(:title, :name)
    end
    respond_to do |format|
      if @equipment.update_attributes(whitelist)
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @equipment.errors, :status => :unprocessable_entity }
      end
    end
  end  
  
  # POST /Equipment/1
  # POST /Equipment/1.json
  def create
    @airframe = Airframe.find(:first, :conditions => ["id = '?' AND user_id = '?'", params[:equipment][:airframe_id], @current_user.id])
    if @airframe.present?
      whitelist = params[:equipment].slice(:title, :name, :etype)
      @equipment = Equipment.create(whitelist)
      @airframe.equipment << @equipment if @equipment && @equipment.errors.count == 0
    end

    respond_to do |format|
      if @equipment.save
        format.html { redirect_to @equipment, :notice => 'Airframe was successfully created.' }
        format.json { render :json => @equipment, :status => :created, :location => @equipment }
      else
        format.html { render :action => "new" }
        format.json { render :json => @equipment.errors, :status => :unprocessable_entity }
      end
    end
    
  end 
    
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

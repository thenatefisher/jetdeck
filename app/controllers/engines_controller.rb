class EnginesController < ApplicationController
  before_filter :authorize

  # GET /engines
  # GET /engines.json
  def index
    @engines = Engine.where("baseline = 't'").group(:model_id)
  end
  
  # PUT /engines/1
  # PUT /engines/1.json
  def update
    @engine = Engine.find(:first, :conditions => ["id = ? AND owner_id = ?", params[:id], @current_user.id])
    whitelist = Hash.new
    whitelist = params[:engine].slice(:year, :modelName, :serial, :smoh, :shsi, :hsi, :tbo, :totalTime, :totalCycles)

    logger.info(whitelist)

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
    @engines = Engine.find(params[:id])
    @engines.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
    
  # POST /engines
  def create
    whitelist = params[:engine].slice(:year, :serial, :smoh, :shsi, :hsi, :tbo, :totalTime, :totalCycles)
    whitelist[:owner_id] = @current_user.id
    if params[:engine][:airframe_id] && params[:engine][:model]
        @engine = Engine.new(whitelist)
        @engine.m |= Equipment.find_by_modelNumber(params[:engine][:model]) 
        @engine.modelName = params[:engine][:model] if params[:engine][:model]
        airframe = Airframe.find(:first, :conditions => ["id = ? AND user_id = ?", params[:engine][:airframe_id], @current_user.id])
        airframe.engines << @engine
        
    end
    
    respond_to do |format|
      if @engine.save
        format.html { redirect_to @engine, :notice => 'Airframe was successfully created.' }
        format.json { render :json => @engine, :status => :created, :location => @engine }
      else
        format.html { render :action => "new" }
        format.json { render :json => @engine.errors, :status => :unprocessable_entity }
      end
    end
  end
      
end

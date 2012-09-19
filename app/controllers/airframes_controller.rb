class AirframesController < ApplicationController
  before_filter :authorize

  # GET /airframes/models
  def models

    if params[:q]
      @airframes = Airframe.find(:all,
        :conditions => ["upper(make || ' ' || model_name) LIKE ?
                             AND (baseline = 't' OR user_id = ?)",
                          "%#{params[:q].to_s.upcase}%",
                          @current_user.id
                       ],
         :select => "DISTINCT ON (model_name) id, *"
      ).first(4)
    end

  end

  # GET /airframes
  # GET /airframes.json
  def index
    @airframes = Airframe.where("user_id = ?", @current_user.id)

    # registration number search
    if params[:term].present?

        @airframes = Airframe.where(
          "upper(registration) like ? AND (baseline = 't' OR user_id = ?)",
          "%"+params[:term].to_s.upcase+"%",
          @current_user.id
        ).first(5)

        if @airframes.nil?
            render :layout => false, :nothing => true, :status => :unprocessable_entity
        else
            render :json => @airframes.to_json( :methods => [:model, :make, :to_s] )
        end

    end

  end

  # GET /airframes/1
  # GET /airframes/1.json
  def show

    if params[:id].present?
        @airframe = Airframe.find(params[:id])
    end

  end

  # GET /airframes/new
  # GET /airframes/new.json
  def new
    @airframe = Airframe.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @airframe }
    end
  end

  # GET /airframes/1/edit
  def edit
    @airframe = Airframe.find(params[:id])
  end

  # POST /airframes
  # POST /airframes.json
  def create
    whitelist = params[:airframe].slice(:registration, :serial, :year)
    whitelist[:user_id] = @current_user.id
    @airframe = Airframe.new(whitelist)

    baseline = Airframe.new()
    if params[:airframe][:baseline_id].present?
        baseline = Airframe.find(:first, :conditions => [
          "baseline = 't' AND id = ?",
          params[:airframe][:baseline_id]])
        if baseline
            @airframe.model_name = baseline.model_name
            @airframe.make = baseline.make
            @airframe.baseline_id = baseline.id
            baseline.engines.each do |e| 
              new_eng = e.dup
              new_eng.user_id = @current_user.id
              @airframe.engines << new_eng 
            end
        end
    end

    if params[:airframe][:headline].present? && params[:airframe][:baseline].nil?
        headline = params[:airframe][:headline]
        headline = headline.split
        if headline.length == 1
            @airframe.make = ""
            @airframe.model_name = headline.first
        else
            @airframe.make = headline.first
            @airframe.model_name = headline.last(headline.length - 1).join(" ")
        end      
    end
    
    respond_to do |format|
      if @airframe.save
        @mixpanel.track_event("Created Airframe", 
          {:baseline => !baseline.new_record?}
        )
        format.html { redirect_to @airframe, :notice => 'Airframe was successfully created.' }
        format.json { render :json => @airframe, :status => :created, :location => @airframe }
      else
        @mixpanel.track_event("Failed Creating Airframe", 
          {:baseline => !baseline.new_record?}
        )      
        format.html { render :action => "new" }
        format.json { render :json => @airframe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /airframes/1
  # PUT /airframes/1.json
  def update

    @airframe = Airframe.find(params[:id])
    
    equipment = Array.new()
    params[:airframe][:equipment].each do |e|
      equipment << e.slice(:etype, :name, :title, :airframe_id, :id)
    end
    params[:airframe][:equipment_attributes] = equipment 
    
    whitelist = params[:airframe].slice(
        :asking_price, :description,
        :serial, :registration, :tt, 
        :tc, :year, :make, :model_name, 
        :equipment_attributes)

    @engines = Array.new()
    params[:airframe][:engines].each do |a|
         
         if a[:id] == "0" && a[:model_name]
         
            newItem = Engine.create(
                :model_name => a[:model_name], 
                :user_id => @current_user.id)
                
            eng_wl = a.slice(:tt, :tc, :serial, :make, :modelName, 
              :name, :year, :smoh, :shsi, :tbo, :hsi)
            newItem.update_attributes(eng_wl) if newItem     
                       
            @engines << newItem if newItem
            @mixpanel.track_event("Created Engine", {:baseline => false})                
         elsif @baseline = Engine.find(
              :first, 
              :conditions => [
                "id = ? AND baseline = 't'", a[:id]])
           
               newItem = @baseline.dup
               newItem.baseline = false
               newItem.user_id = @current_user.id
               newItem.baseline_id = a[:id]
                
               eng_wl = a.slice(:tt, :tc, :serial, :make, :modelName, 
                :name, :year, :smoh, :shsi, :tbo, :hsi)
               newItem.update_attributes(eng_wl) 
                             
               @engines << newItem        
               @mixpanel.track_event("Created Engine", {:baseline => true})     
         else
         
            engine = Engine.find(:first, :conditions => [
              "id = ? AND user_id = ?",
              a[:id],
              @current_user.id])
            
            eng_wl = a.slice(:tt, :tc, :serial, :make, :modelName, 
              :name, :year, :smoh, :shsi, :tbo, :hsi)
            engine.update_attributes(eng_wl) if engine
              
            @engines << engine if engine 
            
         end
         
    end
    whitelist[:engines] = @engines    

    respond_to do |format|
      if @airframe.update_attributes(whitelist)
        @mixpanel.track_event("Updated Airframe") 
        format.html { redirect_to @airframe, 
          :notice => 'Airframe was successfully updated.' }
        format.json { render  :locals => { airframe: @airframe }, 
                              :template => 'airframes/show', 
                              :formats => [:json],
                              :handlers => [:jbuilder] }
      else
        @mixpanel.track_event("Failed Updating Airframe")  
        format.html { render :action => "edit" }
        format.json { render :json => @airframe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /airframes/1
  # DELETE /airframes/1.json
  def destroy
    @airframe = Airframe.find(params[:id])
    @airframe.destroy
    @mixpanel.track_event("Deleted Airframe") 
    respond_to do |format|
      format.html { redirect_to airframes_url }
      format.json { head :no_content }
    end
  end
end

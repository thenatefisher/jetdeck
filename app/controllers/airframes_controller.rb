class AirframesController < ApplicationController
  before_filter :authorize

  # GET /airframes/models
  def models

    if params[:q]
      @airframes = Airframe.find(:all,
        :conditions => ["(make || ' ' || model_name) LIKE ?
                             AND (baseline = 't' OR user_id = ?)",
                          "%#{params[:q]}%",
                          @current_user.id
                       ],
        :group => "model_name"
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
          "registration like ? AND (baseline = 't' OR user_id = ?)",
          "%"+params[:term].to_s+"%",
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

    if params[:airframe][:baseline_id].present?
        baseline = Airframe.find(params[:airframe][:baseline_id])
        if baseline
            @airframe.model_name = baseline.model_name
            @airframe.make = baseline.make
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
        format.html { redirect_to @airframe, :notice => 'Airframe was successfully created.' }
        format.json { render :json => @airframe, :status => :created, :location => @airframe }
      else
        format.html { render :action => "new" }
        format.json { render :json => @airframe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /airframes/1
  # PUT /airframes/1.json
  def update
    @airframe = Airframe.find(params[:id])
    whitelist = params[:airframe].slice(:asking_price, :description,
        :serial, :registration, :tt, :tc, :year, :make, :model_name)

    @engines = []
    params[:airframe][:engines].each do |a|
         @baseline = Engine.find(:first, :conditions => ["id = ? AND (baseline = 't' OR user_id = ?)", a[:id], @current_user.id])
         if @baseline
             newItem = @baseline.dup
             newItem.baseline = false
             newItem.user_id = @current_user
             newItem.baseline_id = a[:id]
             @engines << newItem
         end
    end
    whitelist[:engines] = @engines    

    respond_to do |format|
      if @airframe.update_attributes(whitelist)
        format.html { redirect_to @airframe, :notice => 'Airframe was successfully updated.' }
        format.json { head :no_content }
      else
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

    respond_to do |format|
      format.html { redirect_to airframes_url }
      format.json { head :no_content }
    end
  end
end

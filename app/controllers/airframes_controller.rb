class AirframesController < ApplicationController
  before_filter :authorize, :sanitize_params

  def import

    # defaults
    response = {:status => "UNAUTHORIZED"}
    status = :forbidden

    # find the user
    user = @current_user || User.where(:bookmarklet_token => params[:token]).first

    if user.present?

      # valid user
      status = :ok

      # start airframe import
      airframe = nil
      if params[:url].present? && user.present?
        airframe = Airframe.import(user.id, params[:url])
      end

      # create response
      case airframe.class.name
        when "Delayed::Backend::ActiveRecord::Job"
          response[:status] = "OK"
        when "Airframe"
          response[:status] = "DUPLICATE"
          response[:airframe] = {
            :name => airframe.to_s,
            :link => "http://#{request.host}:#{request.port}/airframes/#{airframe.id}",
          }
        when "NilClass"
          response[:status] = "ERROR"
      end

    end

    # render response
    render :json => response, :callback => params[:callback], :status => status

  end

  # GET /airframes/models
  def models
    if params[:q]
      @airframes = Airframe.find(:all,
        :conditions => ["upper(make || ' ' || model_name) LIKE ?
                             AND user_id = ?",
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
    @airframes = Airframe.find(:all, :conditions => ["user_id = ?", @current_user.id], :order => "created_at DESC")

    # registration number search
    if params[:term].present?

        @airframes = Airframe.where(
          "upper(registration) like ? AND user_id = ?",
          "%"+params[:term].to_s.upcase+"%",
          @current_user.id
        ).first(5)

        if @airframes.nil?
            render :layout => false, :nothing => true
        else
            render :json => @airframes.to_json( :methods => [:model, :make, :to_s] )
        end

    end

  end

  # GET /airframes/1
  # GET /airframes/1.json
  def show

    if params[:id].present?
        @airframe = Airframe.find(:first, :conditions =>
          ["id = ? AND user_id = ?", params[:id], @current_user.id])
    end

  end

  # POST /airframes
  # POST /airframes.json
  def create

    whitelist = params[:airframe].slice(:registration, :serial, :year, :import_url)
    whitelist[:user_id] = @current_user.id
    @airframe = Airframe.new(whitelist)

    # import photos
    #if params[:import_images].present? && params[:import_images_input].present?
    #  @airframe.import_url = params[:import_images_input]
    #end

    # add spec file
    #if params[:upload_spec].present? && params[:upload_spec_input].present?
      #@airframe.import_url = params[:upload_spec]
    #end

    # attmept to parse headline
    if params[:airframe][:headline].present?
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

    @airframe = Airframe.find(:first, :conditions =>
      ["id = ? AND user_id = ?", params[:id], @current_user.id])
        
    whitelist = params[:airframe].slice(
        :asking_price, :description,
        :serial, :registration, :tt, 
        :tc, :year, :make, :model_name)

    respond_to do |format|
      if @airframe.update_attributes(whitelist)
        format.html { redirect_to @airframe, 
          :notice => 'Airframe was successfully updated.' }
        format.json { render  :locals => { airframe: @airframe }, 
                              :template => 'airframes/show', 
                              :formats => [:json],
                              :handlers => [:jbuilder] }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @airframe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /airframes/1
  # DELETE /airframes/1.json
  def destroy
    @airframe = Airframe.find(:first, :conditions =>
      ["id = ? AND user_id = ?", params[:id], @current_user.id])
    @airframe.destroy
    respond_to do |format|
      format.html { redirect_to airframes_url }
      format.json { head :no_content }
    end
  end
end

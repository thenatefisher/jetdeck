class AirframesController < ApplicationController
  before_filter :authorize, :sanitize_params

  # GET /airframes/import
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
        # dont own-goal us

        if params[:url].match(/jetdeck\.co/) || params[:url].match(/herokuapp\.com/)
          response[:status] = "OWNGOAL"
        else
          airframe = Airframe.import(user.id, params[:url])

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

      end

    end

    # render response
    render :json => response, :callback => params[:callback], :status => status

  end

  # GET /airframes/models
  def models
    if params[:q]
      @airframes = Airframe.find(:all,
                                 :conditions => ["upper(make || ' ' || model_name) LIKE ? AND created_by = ?",
                                                 "%#{params[:q].to_s.upcase}%",
                                                 @current_user.id
                                                 ],
                                 :select => "DISTINCT ON (model_name) id, *"
                                 ).first(4)
    end
  end

  def index

    @airframes = @airframes_index

    # registration number search
    if params[:term].present?

      @airframes = Airframe.where(
        "upper(registration) like ? AND created_by = ?",
        "%"+params[:term].to_s.upcase+"%",
        @current_user.id
      ).first(5)

      if @airframes.nil?
        render :layout => false, :nothing => true
      else
        render :json, :template => "airframes/search"
      end

    end

  end

  def show

    if params[:id].present?
      @airframe = Airframe.find(:first, :conditions =>
                                ["id = ? AND created_by = ?", params[:id], @current_user.id])
      render :json, :template => "airframes/show"
    else
      render :json => ["You do not have access to this aircraft"], :status => :unauthorized
    end

  end

  def create

    whitelist = params[:airframe].slice(:registration, :serial, :year, :import_url)
    whitelist[:created_by] = @current_user.id
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

    if @airframe.save
      render :json, :template => "airframes/show", :status => :created
    else
      render :json => @airframe.errors.full_messages, :status => :unprocessable_entity
    end
  end

  def update

    @airframe = Airframe.find(:first, :conditions => ["id = ? AND created_by = ?", params[:id], @current_user.id])

    whitelist = params[:airframe].slice(:asking_price, :description, :serial, :registration, :year, :make, :model_name)

    if params[:airframe][:images].present?
      whitelist[:images_attributes] = params[:airframe][:images].map{|x| x.slice(:id, :thumbnail)}
    end

    if params[:airframe][:leads].present?
      whitelist[:leads_attributes] = params[:airframe][:leads].map{|x| x.slice(:id)}
    end

    if params[:airframe][:todos].present?
      whitelist[:todos_attributes] = params[:airframe][:todos].map{|x| x.slice(:id)}
    end

    if params[:airframe][:specs].present?
      whitelist[:specs_attributes] = params[:airframe][:specs].map{|x| x.slice(:id)}
    end

    if @airframe.update_attributes(whitelist)
      render :json, :template => "airframes/show"
    else
      render :json => @airframe.errors.full_messages, :status => :unprocessable_entity
    end

  end

  def destroy
    @airframe = Airframe.find(:first, :conditions => ["id = ? AND created_by = ?", params[:id], @current_user.id])
    if @airframe.present? && @airframe.destroy
      render :json => true, :status => :ok
    else
      render :json => ["Cannot delete an aircraft that does not exist"], :status => :unprocessable_entity
    end
  end
end

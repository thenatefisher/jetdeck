class AirframeSpecsController < ApplicationController
  before_filter :authorize, :sanitize_params

  def index
    if params[:airframe_spec][:airframe] && Airframe.find(
        :first, :conditions => ["created_by = ? AND id = ?",
                                @current_user.id, params[:airframe_spec][:airframe]])

      @specs = Airframe.find(:first,
                             :conditions => ["created_by = ? AND id = ?", @current_user.id, params[:airframe_spec][:airframe]])
      .specs.find(:all, :order => "created_at DESC")
      render :json => @specs.collect { |p| p.to_jq_upload }.to_json
    else
      render :json => true
    end
  end

  def create
    @spec = AirframeSpec.new(params[:airframe_spec][:files])
    @spec.creator = @current_user
    if Airframe.find(:first, :conditions => ["created_by = ? AND id = ?", @current_user.id, params[:airframe_spec][:airframe_id]]).present?
      @airframe = Airframe.find(:first, :conditions => ["created_by = ? AND id = ?", @current_user.id, params[:airframe_spec][:airframe_id]])
      if @airframe.present?
        @spec.airframe_id = @airframe.id
      end
    end
    if @spec.save
      render :json => {"files" => [@spec.to_jq_upload]}.to_json
    else
      render :json => @spec.errors.full_messages, :status => :unprocessable_entity
    end
  end

  def update
    @spec = AirframeSpec.where(:id => params[:id], :created_by => current_user.id).first
    if @spec.present? && params[:airframe_spec]
      @spec.enabled = (params[:airframe_spec][:enabled])
      logger.warn @spec
      if @spec.save
        logger.warn @spec
        render :json => @spec, :status => :ok
      else
        render :json => @spec.full_messages, :status => :unprocessable_entity
      end
    end
  end

  def destroy
    @spec = AirframeSpec.where(:id => params[:id], :created_by => current_user.id).first
    if @spec.present? && @spec.destroy
      render :json => true, :status => :ok
    else
      render :json => ["Not authorized to delete"], :status => :unprocessable_entity
    end
  end

end

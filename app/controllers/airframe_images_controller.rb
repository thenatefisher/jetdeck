class AirframeImagesController < ApplicationController
  before_filter :authorize, :sanitize_params

  def index

    if params[:airframe_image][:airframe] && Airframe.find(
        :first, :conditions => ["created_by = ? AND id = ?",
                                @current_user.id, params[:airframe_image][:airframe]])

      @images = Airframe.find(:first,
                              :conditions => ["created_by = ? AND id = ?", @current_user.id, params[:airframe_image][:airframe]])
      .images.find(:all, :order => "created_at DESC")
      render :json => @images.collect { |p| p.to_jq_upload }.to_json

    else
      render :json => true
    end

  end

  def create
    logger.warn params.inspect
    @image = AirframeImage.new(params[:files])
    @image.creator = @current_user

    if Airframe.find(:first, :conditions => ["created_by = ? AND id = ?", @current_user.id, params[:airframe]]).present?
      @airframe = Airframe.find(:first, :conditions => ["created_by = ? AND id = ?", @current_user.id, params[:airframe]])
      if @airframe.present?
        @image.airframe_id = @airframe.id
      end
    end

    if @image.save
      render :json => {"files" => [@image.to_jq_upload]}.to_json
    else
      render :json => @image.errors.full_messages, :status => :unprocessable_entity
    end

  end

  def update

    @image = AirframeImage.find(:first, :conditions => ["id = ? AND created_by = ?", params[:id], @current_user.id])
    if @image.present?

      if params[:airframe_image][:thumbnail]
        # make all other images NOT the thumbnail
        @image.airframe.images.each { |a| a.thumbnail = false; a.save }
        # select this one as thumbnail
        @image.thumbnail = true
      end

      if @image.update_attributes(params[:airframe_image].slice(:enabled))
        render :json => @image, :status => :ok
      else
        render :json => @image.full_messages, :status => :unprocessable_entity
      end

    end

  end

  def destroy
    @image = AirframeImage.find(:first, :conditions => ["id = ? AND created_by = ?", params[:id], @current_user.id])
    if @image.present? && @image.destroy
      render :json => true, :status => :ok
    else
      render :json => ["Not authorized to delete"], :status => :unprocessable_entity
    end
  end

end

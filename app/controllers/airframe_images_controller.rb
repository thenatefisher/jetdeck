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

    @image = AirframeImage.new(params[:airframe_image][:files])
    @image.creator = @current_user

    if Airframe.find(:first, :conditions => ["created_by = ? AND id = ?", @current_user.id, params[:airframe_image][:airframe]]).present?
      @airframe = Airframe.find(:first, :conditions => ["created_by = ? AND id = ?", @current_user.id, params[:airframe_image][:airframe]])
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

    @image = AirframeImage.find(params[:id], :created_by => current_user.id)
    if @image.present?

      if params[:airframe_image][:thumbnail]
        # make all other images NOT the thumbnail
        @image.airframe.images.each { |a| a.thumbnail = false; a.save }
        # select this one as thumbnail
        @image.thumbnail = true
      end

      if @image.update_attributes(params[:airframe_image].slice(:enabled))
        render :json => @spec, :status => 200
      else
        render :json => @image.full_messages, :status => :unprocessable_entity
      end

    end

  end

  def destroy

    @image = AirframeImage.find(params[:id], :created_by => current_user.id)
    if @image.present?
      @image.destroy
      render :json => true, :status => 200
    else
      render :json => ['You are not Authorized to delete this image'], :status => :unprocessable_entity
    end

  end

end

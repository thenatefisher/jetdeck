class AirframeMessagesController < ApplicationController

  # GET /s/:code
  def spec

    message = AirframeMessage.find_by_spec_url_code(params[:code])
    @spec = message.airframe_spec

    if message.nil? || @spec.nil? then
        redirect_to "/", :status => 404
        return
    end

    message.status = "Downloaded"
    message.save

    redirect_to @spec.url(5.minutes)

  end

  # GET /p/:code
  def photos

    @message = AirframeMessage.find_by_photos_url_code(params[:code])
    @airframe = @message.airframe

    if @message.nil? then
        redirect_to "/"
        return
    end

    render :layout => 'photos'

  end

end

class AirframeMessagesController < ApplicationController

  # GET /s/:code
  def spec
    airframe_message = AirframeMessage.where(:spec_url_code => params[:code], :spec_enabled => true).first   @spec = airframe_message.airframe_spec
    if airframe_message.blank? || @spec.blank? || !@spec.enabled then
      render :template => 'airframe_messages/missing_spec', :layout => 'error'
    else
      airframe_message.status = 'Downloaded'
      airframe_message.save
      redirect_to @spec.url(5.minutes)
    end
  end

  # GET /p/:code
  def photos
    @airframe_message = AirframeMessage.where(:photos_url_code => params[:code], :photos_enabled => true).first
    @airframe = @airframe_message.airframe
    if @airframe_message.blank? || @airframe.blank? then
      render :template => 'airframe_messages/missing_photos', :layout => 'error'
    else
      render :layout => 'photos'
    end
  end

  def send
    authorize()
    sanitize_params()
    @airframe_message = AirframeMessage.where('id = ? AND created_by = ?', params[:id], @current_user.contact.id).first
    if @airframe_message.present?
      @airframe_message.send_message()
      render :json => @airframe_message.to_json()
    else
      render :json => ['You do not have permission to send this message'], :status => :unprocessable_entity
    end
  end

  def update
    authorize()
    sanitize_params()
    @airframe_message = AirframeMessage.where('id = ? and created_by = ?', params[:id], @current_user.id).first
    if @airframe_message && params[:airframe_message].present?
      whitelist = params[:airframe_message].slice(:photos_enabled, :spec_enabled, :subject, :body)
    end
    respond_to do |format|
      if @airframe_message.update_attributes(whitelist)
        render :json, template: 'airframe_messages/show',
          handlers: [:jbuilder]
      else
        render :json => @airframe_message.errors.full_messages, :status => :unprocessable_entity
      end
    end
  end

  def create
    authorize()
    sanitize_params()
    params[:airframe_message][:recipient_email].strip!
    recipient = Contact.where('email = ? AND created_by = ?', params[:airframe_message][:recipient_email], @current_user.id).first
    recipient ||= Contact.create(:email => params[:airframe_message][:recipient_email])
    recipient.update_attributes({:created_by => @current_user.id}
                                )
    if params[:airframe_message][:airframe_id].present?
      airframe = Airframe.find(:first,
                               :conditions => ['id = ? AND created_by = ?',
                                               params[:airframe_message][:airframe_id],
                                               @current_user.id])
    end
    if airframe.present? && params[:airframe_message][:spec_id].present?
      spec = AirframeSpec.find(:first,
                               :conditions => ['id = ? AND created_by = ? AND airframe_id = ?',
                                               params[:airframe_message][:airframe_spec_id],
                                               @current_user.id,
                                               airframe.id])
    end
    @airframe_message = AirframeMessage.new(
      :recipient => recipient,
      :sender => @current_user,
      :airframe => airframe,
      :body => params[:airframe_message][:body].strip,
      :subject => params[:airframe_message][:subject].strip,
      :photos_enabled => (params[:airframe_message][:include_photos]),
      :spec_enabled => (params[:airframe_message][:include_spec]),
      :airframe_spec => spec
    )
    respond_to do |format|
      if @airframe_message.save && @airframe_message.send_message()
        render :json, template: 'airframe_messages/show',
          handlers: [:jbuilder]
      else
        errors = @airframe_message.errors.full_messages
        errors ||= ['Server Error - Could not send spec']
        render :json => errors, :status => :unprocessable_entity
      end
    end
  end
end

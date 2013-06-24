class AirframeMessagesController < ApplicationController

  # GET /s/:code
  def spec

    message = AirframeMessage.where(:spec_url_code => params[:code], :spec_enabled => true).first
    @spec = message.airframe_spec

    if message.blank? || @spec.blank? || !@spec.enabled then
      render :template => 'airframe_messages/missing_spec', :layout => "missing"
    else
      message.status = "Downloaded"
      message.save
      redirect_to @spec.url(5.minutes)
    end
  end

  # GET /p/:code
  def photos

    @message = AirframeMessage.where(:photos_url_code => params[:code], :photos_enabled => true).first
    @airframe = @message.airframe

    if @message.blank? || @airframe.blank? then
      render :template => 'airframe_messages/missing_photos', :layout => "missing"
    else
      render :layout => 'photos'
    end
  end

  def send

    authorize()
    sanitize_params()

    @message = AirframeMessage.where("id = ? AND created_by = ?", params[:id], @current_user.contact.id).first

    if @message.present?
      @message.send_message()
      render :json => @message.to_json()
    else
      render :json => ['You do not have permission to send this message'], :status => :unprocessable_entity
    end
  end

  def update

    authorize()
    sanitize_params()

    @message = AirframeMessage.where("id = ? and created_by = ?", params[:id], @current_user.id).first

    if @message && params[:airframe_message].present?
      @message.photos_enabled = (params[:airframe_message][:include_photos]) if params[:airframe_message][:include_photos].present?
      @message.spec_enabled = (params[:airframe_message][:include_spec]) if params[:airframe_message][:include_spec].present?
      @message.subject = params[:airframe_message][:subject] if params[:airframe_message][:subject].present?
      @message.body = params[:airframe_message][:body] if params[:airframe_message][:body].present?
    end

    respond_to do |format|

      if @message.save
        render :json => { template: 'airframe_messages/show',
                          handlers: [:jbuilder],
                          formats: [:json],
                          locals: { airframe_message: @message}  }
      else
        render :json => @message.errors.full_messages, :status => :unprocessable_entity
      end

    end
  end

  def create

    authorize()
    sanitize_params()

    params[:airframe_message][:recipient_email].strip!
    recipient = Contact.where("email = ? AND created_by = ?", params[:airframe_message][:recipient_email], @current_user.id).first

    # create a contact record if none found
    if recipient.blank?
      recipient = Contact.create(:email => params[:airframe_message][:recipient_email])
      recipient.created_by = @current_user.id if recipient.present?
      recipient.save
    end

    if params[:airframe_message][:airframe_id].present?
      airframe = Airframe.find(:first,
                               :conditions => ["id = ? AND created_by = ?", params[:airframe_message][:airframe_id], @current_user.id])
    end

    if airframe && params[:airframe_message][:spec_id].present?
      spec = AirframeSpec.find(:first,
                               :conditions => ["id = ? AND created_by = ? AND airframe_id = ?", params[:airframe_message][:airframe_spec_id], @current_user.id, airframe.id])
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
        render :json => {} template: 'airframe_messages/show',
          handlers: [:jbuilder],
          formats: [:json],
          locals: { airframe_message: @airframe_message}
      else
        errors = @airframe_message.errors.full_messages
        errors = ["Server Error - Could not send spec"] if @airframe_message.errors.full_messages.empty?
        render :json => errors, :status => :unprocessable_entity
      end

    end
  end

end

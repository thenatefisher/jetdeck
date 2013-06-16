class LeadsController < ApplicationController

  before_filter :sanitize_params

  include ActionView::Helpers::NumberHelper
  
  def send_spec

      authorize()
 
      @lead = Lead.where("id = ? AND sender_id = ?", params[:id], @current_user.contact.id).first
      
      if @lead

        subject = "subject of message"
        body = "body of message"

        LeadMailer.sendSpec(@lead, subject, body).deliver
        
        render :json => @lead.to_json()
      
      end
      
  end

  def recordTimeOnPage

    xspec = Xspec.where(:url_code => params[:code]).first

    if xspec.present?
        specView = xspec.views.where(
            :ip => request.remote_ip
        ).last

        if specView.present?
            specView.time_on_page = params[:time] if params[:time].present?
            specView.save()
        end
    end

    render :nothing => true

  end

  # GET /s/:code
  def photos

    @xspec = Xspec.find_by_url_code!(params[:code])
    @airframe = @xspec.airframe

    if @xspec.nil? then
        redirect_to "/"
        return
    else
      if current_user.nil? 
        @xspec.views << SpecView.create(:agent => request.user_agent, :ip => request.remote_ip)
      end
    end

    render :layout => 'retail'

  end

  def show
  
    authorize() 
    
    @lead = Lead.where(
      "id = ? AND sender_id = ?", 
      params[:id],  
      @current_user.id
    ).first
    @airframe = @lead.airframe
    
  end

  def update
  
    authorize()
    
    @lead = Lead.where("id = ? and sender_id = ?", params[:id], @current_user.id).first

    params[:lead]['recipient_email'].strip!
    recipient = Contact.where(
      "email = ? AND owner_id = ?", 
      params[:lead]['recipient_email'], 
      @current_user.id).first
    # create a contact record if none found
    if recipient.nil?
        recipient = Contact.create(:email => params[:lead]['recipient_email'])
        recipient.owner_id = @current_user.id if recipient.present?
        recipient.save
    end
    
    airframe = Airframe.find(:first, 
      :conditions => ["id = ? AND user_id = ?", params[:lead]['airframe_id'], @current_user.id])

    @lead.recipient = recipient
    @lead.airframe = airframe
    @lead.photos_enabled = (params[:lead]['include_photos'])

    respond_to do |format|
    
      if @lead.save

        format.json { render( template: 'leads/show',
                              handlers: [:jbuilder],
                              formats: [:json],
                              locals: { lead: @lead} ) }
      else
      
        format.json { render :json => @lead.errors.full_messages, :status => :unprocessable_entity }
        
      end
      
    end  

  end

  def create
    
    authorize()
    
    params[:lead]['recipient_email'].strip!
    recipient = Contact.where("email = ? AND owner_id = ?", params[:lead]['recipient_email'], @current_user.id).first
    # create a contact record if none found
    if recipient.nil?
        recipient = Contact.create(:email => params[:lead]['recipient_email'])
        recipient.owner_id = @current_user.id if recipient.present?
        recipient.save
    end
    
    airframe = Airframe.find(:first, 
      :conditions => ["id = ? AND user_id = ?", params[:lead]['airframe_id'], @current_user.id])

    spec = Accessory.find(:first, 
      :conditions => ["id = ? AND creator_id = ?", params[:lead]['spec_id'], @current_user.id])

    @lead = Lead.new(
      :recipient => recipient, 
      :sender => @current_user, 
      :airframe => airframe,
      :body => params[:lead]['message_body'].strip,
      :subject => params[:lead]['message_subject'].strip,
      :photos_enabled => (params[:lead]['include_photos']),
      :spec => spec,
      :spec_enabled => true
    )

    respond_to do |format|
    
      if @lead.save

        if params[:lead]['send'] == "true"
        
          XSpecMailer.sendRetail(@lead, @lead.recipient).deliver
          
        end

        format.json { render( template: 'leads/show',
                              handlers: [:jbuilder],
                              formats: [:json],
                              locals: { lead: @lead} ) }
      else
      
        format.json { render :json => @lead.errors.full_messages, :status => :unprocessable_entity }
        
      end
      
    end
    
  end

  def destroy
  
    authorize()
    
    @xspec = Lead.where("id = ? AND sender_id = ?", params[:id], @current_user.id).first
    
    if @xspec
       @xspec.destroy()
    end
    
    respond_to do |format|
      format.json { head :no_content }
    end
    
  end
  
end

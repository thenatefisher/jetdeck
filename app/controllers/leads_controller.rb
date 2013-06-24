class LeadsController < ApplicationController
  before_filter :authorize, :sanitize_params
  
  def send_spec

      authorize()
 
      @lead = Lead.where("id = ? AND sender_id = ?", params[:id], @current_user.contact.id).first
      
      if @lead

        @lead.subject = "subject of message"
        @lead.body = "body of message"
        @lead.save

        LeadMailer.sendSpec(@lead).deliver
        
        render :json => @lead.to_json()
      
      end
      
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
    
    if params[:lead]['airframe_id'].present?
      airframe = Airframe.find(:first, 
        :conditions => ["id = ? AND user_id = ?", params[:lead]['airframe_id'], @current_user.id])
    end

    if airframe && params[:lead]['spec_id'].present?
      spec = Accessory.find(:first, 
        :conditions => ["id = ? AND creator_id = ? AND airframe_id = ?", params[:lead]['spec_id'], @current_user.id, airframe.id])
    end

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
    
      if @lead.save && LeadMailer.sendSpec(@lead).deliver

        format.json { render( template: 'leads/show',
                              handlers: [:jbuilder],
                              formats: [:json],
                              locals: { lead: @lead} ) }
      else
        
        errors = @lead.errors.full_messages 
        errors = ["Server Error - Could not send spec"] if @lead.errors.full_messages.empty?

        format.json { render :json => errors, :status => :unprocessable_entity }
        
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

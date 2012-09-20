class XspecsController < ApplicationController
  include ActionView::Helpers::NumberHelper
  
  def send_spec

      authorize()
 
      @xspec = Xspec.where("id = ? AND sender_id = ?", params[:id], @current_user.contact.id).first
      
      if @xspec

        XSpecMailer.sendRetail(@xspec, @xspec.recipient).deliver
        
        render :json => @spec.to_json()
      
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
  def retail

    @xspec = Xspec.find_by_url_code!(params[:code])
    @airframe = @xspec.airframe

    if @xspec.nil? then
        redirect_to "/"
        return
    else
      if @current_user.nil?
        @xspec.views << SpecView.create(:agent => request.user_agent, :ip => request.remote_ip)
      end
    end

    render :layout => 'retail'

  end

  def show
  
    authorize() 
    
    @xspec = Xspec.where(
      "id = ? AND sender_id = ?", 
      params[:id],  
      @current_user.contact.id
    ).first
    @backgrounds = XspecBackground.all
    @airframe = @xspec.airframe
    
  end

  def create
    
    authorize()
    
    sender = @current_user.contact

    recipient = Contact.where("email = ? AND owner_id = ?", params[:xspec]['recipient_email'], @current_user.id).first
    
    # create a contact record if none found
    if recipient.nil?
        recipient = Contact.create(:email => params[:xspec]['recipient_email'])
        recipient.owner_id = @current_user.id if recipient.present?
        recipient.baseline = false if recipient.present?
        recipient.save
    end
    
    af = Airframe.find(:first, :conditions => ["id = ? AND user_id = ?", params[:xspec]['airframe_id'], @current_user.id])

    @xspec = Xspec.new(:recipient => recipient, :sender => sender, :airframe => af )

    respond_to do |format|
    
      if @xspec.save

        if params[:xspec]['send'] == "true"
        
          XSpecMailer.sendRetail(@xspec, @xspec.recipient).deliver
          
        end

        format.json { render( template: 'xspecs/show',
                              handlers: [:jbuilder],
                              formats: [:json],  
                              locals: { xspec: @xspec} ) }
      else
      
        format.json { render :json => @xspec.errors, :status => :unprocessable_entity }
        
      end
      
    end
    
  end

  def update

      if current_user.nil? && params[:spec][:url_code] && params[:spec][:show_message]

        @xspec = Xspec.where("url_code = ?", params[:spec][:url_code]).first
        @xspec.update_attributes(params[:spec].slice(:show_message))
        render :nothing => true
        return 
        
      end
      
      authorize()
      
      @xspec = Xspec.where("id = ? AND sender_id = ?", params[:id], @current_user.contact.id).first
      
      if @xspec
      
        @whitelist = params[:spec].slice(
          :message, 
          :salutation, 
          :headline1, 
          :headline2, 
          :headline3,
          :show_message, 
          :override_description,
          :override_price,
          :hide_price,
          :hide_registration, 
          :hide_serial, 
          :hide_location,
          :background_id   
        )
        
      else
          render :nothing => true
          return
      end

      respond_to do |format|
      
        if @xspec.update_attributes(@whitelist)
          format.html { redirect_to @xspec, :notice => 'Spec was successfully updated.' }
          format.json { head :no_content }
        elsif @xspec.errors
          format.html { render :action => "edit" }
          format.json { render :json => @xspec.errors, :status => :unprocessable_entity }
        end
        
      end
        
  end
  
  def destroy
  
    authorize()
    
    @xspec = Xspec.where("id = ? AND sender_id = ?", params[:id], @current_user.contact.id).first
    
    if @xspec
       @xspec.destroy()
    end
    
    respond_to do |format|
      format.json { head :no_content }
    end
    
  end
  
end

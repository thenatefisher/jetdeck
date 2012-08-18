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

    @xspec = Xspec.where(:url_code => params[:code]).first
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

  # GET /specs/1
  def show
  
    authorize() 
    
    @xspec = Xspec.where("id = ? AND sender_id = ?", params[:id], @current_user.contact.id).first
    @backgrounds = XspecBackground.all
    @airframe = @xspec.airframe
    
  end

  # POST /specs
  # POST /specs.json
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

        if params[:xspec]['send']
        
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

  # PUT /specs/1
  # PUT /specs/1.json
  def update

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
        
      
      elsif params[:spec][:url_code]
      
        @xspec = Xspec.where("url_code = ?", params[:spec][:url_code]).first
        @whitelist = params[:spec].slice(:show_message)
                
      end


      respond_to do |format|
        if @xspec.update_attributes(@whitelist)
          format.html { redirect_to @spec, :notice => 'Spec was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render :action => "edit" }
          format.json { render :json => @spec.errors, :status => :unprocessable_entity }
        end
      end
      
  end

end

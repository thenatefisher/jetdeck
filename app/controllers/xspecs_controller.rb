class XspecsController < ApplicationController
  before_filter :authorize
  include ActionView::Helpers::NumberHelper
  
  # GET /specs
  # GET /specs.json
  def index
    @specs = Xspec.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @specs }
    end
  end

  def recordTimeOnPage

    xspec = Xspec.where(:url_code => params[:code]).first

    if xspec.present?
        specView = xspec.views.where(
            :agent => request.user_agent,
            :ip => request.remote_ip
        ).first

        if specView.present?
            specView.timeOnPage = params[:time] if params[:time].present?
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
        @xspec.views << SpecView.create(:agent => request.user_agent, :ip => request.remote_ip)
    end

    render :layout => 'retail'

  end

  # GET /specs/new
  # GET /specs/new.json
  def new
    @spec = Xspec.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @spec }
    end
  end

  # GET /specs/1
  def show
  
    @xspec = Xspec.where("id = ? AND sender_id = ?", params[:id], @current_user.contact.id).first
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

    @spec = Xspec.new(:recipient => recipient, :sender => sender, :airframe => af )

    respond_to do |format|
      if @spec.save
        # todo @spec.send_spec()
        XSpecMailer.sendRetail(@spec, @spec.recipient).deliver
        #format.html { redirect_to "#{root_url}s/#{CGI.escape(@spec.url_code)}" }
        format.json { render :json => @spec.to_json(:include => 'recipient'), :status => :created, :location => @spec }
      else
        format.json { render :json => @spec.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /specs/1
  # PUT /specs/1.json
  def update
   @xspec = Xspec.where("id = ? AND sender_id = ?", params[:id], @current_user.contact.id).first
   
   whitelist = params[:spec].slice(
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
    
    respond_to do |format|
      if @xspec.update_attributes(whitelist)
        format.html { redirect_to @spec, :notice => 'Spec was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @spec.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /specs/1
  # DELETE /specs/1.json
  def destroy
    @spec = Xspec.find(params[:id])
    @spec.destroy

    respond_to do |format|
      format.html { redirect_to specs_url }
      format.json { head :no_content }
    end
  end
end

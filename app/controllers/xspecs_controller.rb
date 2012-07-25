class XspecsController < ApplicationController
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

    xspec = Xspec.where(:urlCode => params[:code]).first

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

  # GET /specs/1
  # GET /specs/1.json
  def show

    @spec = Xspec.where(:urlCode => params[:code]).first
    @airframe = @spec.airframe

    if @spec.nil? then
        redirect_to "/"
        return
    else
        @spec.views << SpecView.create(:agent => request.user_agent, :ip => request.remote_ip)
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

  # GET /specs/1/edit
  def edit
    @spec = Xspec.find(params[:id])
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
        #format.html { redirect_to "#{root_url}s/#{CGI.escape(@spec.urlCode)}" }
        format.json { render :json => @spec.to_json(:include => 'recipient'), :status => :created, :location => @spec }
      else
        format.json { render :json => @spec.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /specs/1
  # PUT /specs/1.json
  def update
    @spec = Xspec.find(params[:id])

    respond_to do |format|
      if @spec.update_attributes(params[:spec])
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

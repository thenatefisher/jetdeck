class ContactsController < ApplicationController

  before_filter :authorize, :sanitize_params, :airframes_index

  # GET /contacts/search
  def search

    if params[:term]
      @contacts = Contact.find(:all,
        :conditions => ["upper(first || ' ' || last || ' ' || email) LIKE ?
                             AND owner_id = ?",
                          "%#{params[:term].to_s.upcase}%",
                          @current_user.id
                       ],
         :select => "DISTINCT ON (id) id, *"
      ).first(4)
    end

  end
  
  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = @current_user.contacts

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @contacts }
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show

    @contact = Contact.find(:first, 
      :conditions => [
        "id = ? AND owner_id = ?", 
        params[:id], 
        @current_user.id]
    )

  end

  # GET /contacts/new
  # GET /contacts/new.json
  def new
    @contact = Contact.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.find(params[:id])
  end

  # POST /contacts
  # POST /contacts.json
  def create
    whitelist = params[:contact].slice(:first, :last, :company, :email, :phone)

    @contact = Contact.new(whitelist)
    @contact.owner_id = @current_user.id

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, :notice => 'Contact was successfully created.' }
        format.json { render :json => @contact, :status => :created, :location => @contact }
      else
        format.html { render :action => "new" }
        format.json { render :json => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.json
  def update

    @contact = Contact.find(:first, :conditions =>
      ["id = ? AND owner_id = ?", params[:id], @current_user.id])
        
    whitelist = params[:contact].slice(
        :id,
        :first,
        :last,
        :company,
        :phone,
        :email, 
        :email_confirmation,
        :sticky_id
      )

    respond_to do |format|
      if @contact.update_attributes(whitelist)
        format.json { render :json => @contact }
      else
        format.json { render :json => @contact.errors, :status => :unprocessable_entity }
      end
    end

  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact = Contact.find(:first, :conditions =>
      ["id = ? AND owner_id = ?", params[:id], @current_user.id])
      
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to contacts_url }
      format.json { head :no_content }
    end
  end
end

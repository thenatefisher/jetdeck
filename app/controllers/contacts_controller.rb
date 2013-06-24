class ContactsController < ApplicationController

  before_filter :authorize, :sanitize_params, :airframes_index

  # GET /contacts/search
  def search

    if params[:term]
      @contacts = Contact.find(:all,
                               :conditions => ["upper(first || ' ' || last || ' ' || email) LIKE ? AND creator_id = ?",
                                               "%#{params[:term].to_s.upcase}%",
                                               @current_user.id
                                               ],
                               :select => "DISTINCT ON (id) id, *"
                               ).first(4)
    end

  end

  def index
    @contacts = @current_user.contacts

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @contacts }
    end
  end

  def show

    @contact = Contact.find(:first,
                            :conditions => ["id = ? AND creator_id = ?",
                                            params[:id],
                                            @current_user.id]
                            )

  end

  def new
    @contact = Contact.new
    render :json => @contact
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def create
    whitelist = params[:contact].slice(:first, :last, :company, :email, :phone)

    @contact = Contact.new(whitelist)
    @contact.creator_id = @current_user.id

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

  def update

    @contact = Contact.find(:first, :conditions =>
                            ["id = ? AND creator_id = ?", params[:id], @current_user.id])

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


    if @contact.update_attributes(whitelist)
      render :json => @contact
    else
      render :json => @contact.errors.full_messages, :status => :unprocessable_entity
    end


  end

  def destroy
    @contact = Contact.find(:first, :conditions =>
                            ["id = ? AND creator_id = ?", params[:id], @current_user.id])

    @contact.destroy

    format.html { redirect_to contacts_url }

  end
end

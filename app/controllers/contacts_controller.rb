class ContactsController < ApplicationController
  before_filter :authorize, :sanitize_params

  # /contacts/search
  def search

    if params[:term]
      @contacts = Contact.find(:all,
                               :conditions => ["(upper(email) LIKE ? OR upper(first || ' ' || last) LIKE ?) AND created_by = ?",
                                               "%#{params[:term].to_s.upcase}%","%#{params[:term].to_s.upcase}%",
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
                            :conditions => ["id = ? AND created_by = ?",
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
    @contact.created_by = @current_user.id

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, :notice => "Contact was successfully created." }
        format.json { render :json => @contact, :status => :created, :location => @contact }
      else
        format.html { render :action => "new" }
        format.json { render :json => @contact.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end

  def update

    @contact = Contact.find(:first, :conditions =>
                            ["id = ? AND created_by = ?", params[:id], @current_user.id])

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
    @contact = Contact.find(:first, :conditions => ["id = ? AND created_by = ?", params[:id], @current_user.id])
    if @contact && @contact.destroy
      render :json => true, :status => :ok
    else
      render :json => ["Not authorized to delete"], :status => :unprocessable_entity
    end
  end
end

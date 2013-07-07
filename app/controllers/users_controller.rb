class UsersController < ApplicationController
  before_filter :sanitize_params

  def activate
    if params[:token].present?
      user = User.find(:first, :conditions =>
                       ["activated != true AND activation_token = ?", params[:token]])
      if user.update_attributes({:activated => true})
        flash[:notice] = "Account Activated!"
        redirect_to "/login"
      else
        flash[:notice] = "Activation token not found."
        redirect_to "/login"
      end
    end
  end

  def new
    if current_user.present?
      redirect_to airframes_url
    else
      invite = Invite.find_by_token(params[:token])

      if invite
        if invite.activated
          flash[:notice] = "Invite already activated!"
          redirect_to "/login"
          return
        end
        # fill in form values
        @email = invite.email
        @name = invite.name
        @token = params[:token]
      end

      render :layout => "signup"
    end
  end

  def create

    # if email, first and last name not supplied, cancel reg
    name = params[:name].split(" ") if params[:name].present?
    if params[:email].blank? || name.blank? || name.count < 2
      flash[:alert] = "Email, First and Last Names Required"
      render :layout => "signup", :action => :new
      return
    end

    # if a user already has this email addy, cancel reg
    if User.find(:first, :include => :contact,
                 :conditions => ["lower(contacts.email) = ?", params[:email].downcase]).present?
      flash[:alert] = "#{params[:email]} is already registered! <a href='login'>Sign In</a>"
      render :layout => "signup", :action => :new
      return
    end

    # create contact record
    contact = Contact.create(:email => params[:email], :first => name[0], :last => name[1])
    
    begin 

      # attempt creation of user
      user = User.create(:contact_id => contact.id, :password => params[:password]) if contact.valid?

      # deactivate all invites with this email address
      Invite.find(:all, :conditions => ["lower(email) = ?", params[:email].downcase]).each do |i|
        i.update_attributes({:activated => true}) # means it was used, ie deactivate
      end

      # send activation email
      UserMailer.activation(user).deliver

      # log user in
      cookies[:auth_token] = user.auth_token

      # redirect to default page
      redirect_to "/"

    rescue => error
      
      logger.warn error.message 

      error_messages = contact.errors.full_messages.join(";")

      # cleanup and send user to normal signup page
      contact.destroy! rescue nil
      flash[:alert] = "Account could not be created"
      flash[:alert] = error_messages if error_messages.present?

      render :layout => "signup", :action => :new

    end

  end

end

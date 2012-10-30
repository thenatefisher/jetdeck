class UsersController < ApplicationController

  def activate
    if params[:token]
      user = User.find(:first, :conditions => 
        ["activation_token = ? AND activation_token IS NOT NULL", params[:token]])
      user.activated = true
      user.save
      
      flash[:notice] = "Account Activated!"
      redirect_to "/login"
    end
  end
  
  def new

    invite = Invite.find_by_token(params[:token])
    
    # invites required
    if !invite
    
      redirect_to "http://www.jetdeck.co/signup.php"
      return
      
    elsif invite.activated
    
      flash[:notice] = "Invite already activated!"
      redirect_to "/login"
      return
      
    end
    
    # fill in form values
    @email = invite.email
    @name = invite.name
    @token = params[:token]

    render :layout => "signup"

  end

  def create

    # if no token, cancel
    if !Invite.find_by_token(params[:token])
      redirect_to "http://www.jetdeck.co/signup.php"
      return    
    end
    
    # if a user already has this email addy, cancel reg
    email = params[:email]
    if !email || !Contact.where(:email => email, :owner_id => -1).empty?
      flash[:alert] = "#{params[:email]} is already registered!"  
      redirect_to request.referer
      return
    end
    
    # if first and last name not supplied, cancel reg
    name = params[:name].split(" ") if params[:name]
    if !name || name.count < 2 
      flash[:alert] = "First and Last Names Required"
      redirect_to request.referer
      return
    end
    
    # create user records
    contact = Contact.create(:email => params[:email], :first => name[0], :last => name[1])
    user = User.create(:contact_id => contact.id, :password => params[:password]) if contact
    
    if user
    
      # deactivate all invites with this email address
      Invite.where(:email => params[:email]).each do |i|
        i.activated = true
        i.save
      end
      
      # send activation email
      ActivationMailer.activation(user).deliver
     
      # log user in
      cookies[:auth_token] = user.auth_token     

      # redirect to default page
      redirect_to "/"
      return
      
    else
    
      # cleanup and send user to normal signup page
      contact.destroy
      redirect_to "http://www.jetdeck.co/signup.php"
      return
    
    end

  end

end

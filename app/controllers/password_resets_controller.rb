class PasswordResetsController < ApplicationController
    
    before_filter :sanitize_params
    
    def index
        render :layout => "login"       
    end

    def create
      contact = Contact.find(:first, :conditions => ["email = ? AND owner_id = -1", params[:email]])
      if contact
          user_record = contact.user 
          if user_record.present?
            user_record.send_password_reset 
            redirect_to login_url, :notice => "Email sent with password reset instructions."
          else
            redirect_to password_resets_url, :notice => "User not found."
          end
      else
        redirect_to password_resets_url, :notice => "User not found."
      end
    end

    def edit
      @user = User.find_by_password_reset_token!(params[:id])
      render :layout => "login" 
    end

    def update
      @user = User.find_by_password_reset_token!(params[:id])
      if @user.password_reset_sent_at < 2.hours.ago
        redirect_to new_password_resets_path, :alert => "Password reset has expired."
      elsif @user.update_attributes(params[:user])
        redirect_to airframes_url, :notice => "Password has been reset!"
      else
        render :edit, :layout => "login"   
      end
    end

end

class PasswordResetsController < ApplicationController
    
    def index
        render :layout => "login"       
    end

    def create
      contact = Contact.find_by_email(params[:email])
      if contact
          user_record = contact.user 
          if user_record.present?
            user_record.send_password_reset 
            mixpanel.track_event("Password Reset Token Sent")
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
    end

    def update
      @user = User.find_by_password_reset_token!(params[:id])
      if @user.password_reset_sent_at < 2.hours.ago
        redirect_to new_password_resets_path, :alert => "Password reset has expired."
      elsif @user.update_attributes(params[:user])
        @mixpanel.track_event("Password Reset Successful")
        redirect_to airframes_url, :notice => "Password has been reset!"
      else
        render :edit
      end
    end

end

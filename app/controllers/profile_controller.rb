class ProfileController < ApplicationController

    before_filter :authorize

    # GET /profile
    # GET /profile.json
    def index
      @user = @current_user
    end

    # PUT /profile/1
    # PUT /profile/1.json
    def update
    
        if params[:profile][:password_confirmation]

           @current_user.update_attributes(
                  params[:profile].slice(:password,:password_confirmation))
                  
           if @current_user.errors.count > 0
              render :json => @current_user.errors, 
                      :status => :unprocessable_entity 
           else
              render :json => @current_user  
           end
            
        elsif params[:profile][:contact]
            contact_whitelist = params[:profile][:contact].slice(
              :email,
              :email_confirmation,
              :first,
              :last,
              :phone,
              :website,
              :company)

            @current_user.contact.update_attributes(contact_whitelist)
            
            if @current_user.contact.errors.count > 0
              render :json => @current_user.contact.errors, 
                      :status => :unprocessable_entity
            else
              render :json => @current_user.contact 
            end
            
        end

    end

end

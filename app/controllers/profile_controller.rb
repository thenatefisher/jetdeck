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

    if params[:profile][:contact]
        contact_whitelist = params[:profile][:contact].slice(
          :email,
          :email_confirmation,
          :first,
          :last,
          :company)

        respond_to do |format|
          if @current_user.contact.update_attributes(contact_whitelist)
            format.html { render :json => @current_user }
            format.json { render :json => @current_user }
          else
            format.html { render :action => "edit" }
            format.json { render :json => @current_user.contact.errors, :status => :unprocessable_entity }
          end

        end

    end

  end

end

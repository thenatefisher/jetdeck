class UsersController < ApplicationController

  # GET /users/new
  # GET /users/new.json
  def new
  
    #@user = User.find_by_password_reset_token!(params[:id])
    @user = User.first
    
    respond_to do |format|
      if @user
        format.html {render :layout => "login"}
      else
        format.html { render :text => "Unauthorized" }
      end
    end
    
  end

  # POST /users
  # POST /users.json
  def create

    @user = User.find_by_password_reset_token!(params[:token])
    
    @user.update_attributes(params[:user].slice(
      :first, 
      :last, 
      :password, 
      :password_confirmation
      )
    )
    
    respond_to do |format|
      if @user.save
        @user.password_reset_token = nil
        @user.save
        format.html { redirect_to profile_path, :notice => 'User was successfully created.' }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end



end

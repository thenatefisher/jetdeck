class SessionsController < ApplicationController
  def new
    if current_user.present?
      redirect_to airframes_url
    else
      render :layout => "login"
    end
  end
  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      reset_session
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      redirect_to airframes_url
    else
      flash[:error] = "Invalid login."
      flash[:email] = params[:email]
      redirect_to login_url
    end
  end
  def destroy
    cookies.delete(:auth_token)
    redirect_to login_url, :notice => "Logged out!"
  end
end

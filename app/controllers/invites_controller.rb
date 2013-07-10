class InvitesController < ApplicationController
  before_filter :authorize, :sanitize_params

  # sends an invite
  def create

    invite = Invite.new(
      :name => params[:invite][:name],
      :message => params[:invite][:message],
      :email => params[:invite][:email],
      :sender => @current_user)

    if invite.save

      # mail invite
      UserMailer.invite(invite).deliver

      # decrement invite counter
      @current_user.invites_available -= 1
      @current_user.save

      # reply OK
      render :json => @current_user, :status => :ok

    else

      render :json => invite.errors.full_messages, :status => :unprocessable_entity

    end

  end

end

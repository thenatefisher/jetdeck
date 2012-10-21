class InvitesController < ApplicationController
    before_filter :authorize
    
    # sends an invite
    def create

      invite = Invite.new(
        :name => params[:invite][:name],
        :message => params[:invite][:message],
        :email => params[:invite][:email], 
        :sender => @current_user)

      if invite.save
        
        # mail invite
        InvitesMailer.invite(invite).deliver
  
        # decrement invite counter
        @current_user.invites -= 1
        @current_user.save
        
        # reply OK
        render :json => @current_user
      
      else
      
        render :json => invite.errors, :status => :unprocessable_entity
      
      end

    end
    
end

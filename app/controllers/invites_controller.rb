require 'bcrypt'

class InvitesController < ApplicationController
    before_filter :authorize
    
    # sends an invite
    def create

        if @current_user.invites > 0
        
          # dont create the invite if a user already exists
          if Contact.find(:first, :conditions => ["email = ? AND owner_id IS NULL", params[:recipient]]).present?
            render :text => "error", :alert => "User Exists"
            return
          end
          
          # otherwise try to create one
          invite = Invite.create(:email => params[:recipient], :from_user_id => @current_user.id)

          if invite
          
            # add the message
            invite.message = params[:message]
            
            # mail invite
            InvitesMailer.invite(invite).deliver
      
            # decrement invite counter
            @current_user.use_invite
            
            # reply OK
            render :text => @current_user
          
          else
          
            render :text => "error", :alert => "Could not create invite"
          
          end
          
        else
        
          render :text => "error", :alert => "No Invites Left"
          
        end

    end
    
end

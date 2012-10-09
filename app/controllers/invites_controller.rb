require 'bcrypt'

class InvitesController < ApplicationController
    before_filter :authorize
    
    def create

        if @current_user.invites > 0
        
          c = Contact.create(:email => params[:recipient]) if params[:recipient].present? 
          u = User.create(:contact_id => c.id, :password => BCrypt::Engine.generate_salt) if c

          if u
          
            # mail invite
            u.generate_token(:password_reset_token)
            u.save
            InvitesMailer.invite(u, @current_user).deliver
      
            # decrement invite counter
            @current_user.use_invite
            
            # reply OK
            render :text => @current_user
          
          end
          
        else
        
          render :text => "No Invites Left"
          
        end

    end
    
end

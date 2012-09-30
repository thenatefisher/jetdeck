class ApplicationController < ActionController::Base
    protect_from_forgery
            
    private

    helper_method :current_user, :actions_due_count # makes the data available in views
    
    def current_user
        @current_user ||= User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
    end
    
    def actions_due_count
        @actions_due_count = @current_user.actions.find(:all, :conditions => 
          ["is_completed != 'true' AND DATE(due_at) < DATE(?)", Time.now()]).count if @current_user.present?
    end
    
    def actions_due_today(user = null)
    
        retval = false
        
        if user.present?
        
          @actions_due_today = user.actions.find(:all, :conditions => 
            ["is_completed != 'true' AND DATE(due_at) = DATE(?)", Time.now()]).count 
            
          if @actions_due_today == 1
            retval = "You have an action due today"
          elsif @actions_due_today > 1
            retval = "You have #{@actions_due_today} actions due today"
          end

        end
        
        retval
        
    end
    
    def authorize
        redirect_to login_url, alert: "Not authorized" if current_user.nil?
    end
    

end

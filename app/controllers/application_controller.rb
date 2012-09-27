class ApplicationController < ActionController::Base
    protect_from_forgery
            
    private

    helper_method :current_user, :actions_due_count # makes the data available in views
    
    def current_user
        @current_user ||= User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
    end
    
    def actions_due_count
        @actions_due_count = @current_user.actions.find(:all, 
          :conditions => ["is_completed = 'f' AND due_at < ?", Time.now()]).count if @current_user.present?
    end

    def authorize
        redirect_to login_url, alert: "Not authorized" if current_user.nil?
    end
    

end

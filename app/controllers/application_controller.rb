class ApplicationController < ActionController::Base
    protect_from_forgery
            
    private

    helper_method :current_user
    before_filter :init_mixpanel
    
    def current_user
        @current_user ||= User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
    end

    def authorize
        redirect_to login_url, alert: "Not authorized" if current_user.nil?
    end
    
    def init_mixpanel
      @mixpanel ||= Mixpanel::Tracker.new(
        Jetdeck::Application.config.mixpanel_token, 
        request.env, 
        { :persist => true }
      )
      if current_user
        @mixpanel.append_api("name_tag", current_user.contact.email)
        @mixpanel.append_api("people.identify", current_user.id)
        @mixpanel.append_person_event({
          :email => current_user.contact.email,
          :created => current_user.created_at,
          :first_name => current_user.contact.first,
          :last_name => current_user.contact.last,
          :specs => current_user.airframes.count
        })
      end
    end
end

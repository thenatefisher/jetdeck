class ApplicationController < ActionController::Base

    protect_from_forgery
    
    include ActionView::Helpers::SanitizeHelper
         
    private

    helper_method :current_user, :airframes_index, :actions_due_count # makes the data available in views
    
    def sanitize_params
    
      sanitize_array(params)

    end

    def sanitize_array(arr)

      arr.each do |k,v|
      
        if v.class < Hash

          sanitize_array(v)
          
        elsif v.class.name == "String"
        
          tags = %w(a acronym b strong i em li ul ol h1 h2 h3 h4 h5 h6 blockquote br cite sub sup ins p)
          output = sanitize(v, :tags => tags, :attributes => %w(href title))
          arr[k] = output
          
        end
        
      end

    end
    
    def current_user
    
        @current_user ||= User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
        
    end

    def airframes_index

        @airframes = Airframe.find(:all, :conditions => ["user_id = ?", @current_user.id], :order => "created_at DESC")

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

class ApplicationController < ActionController::Base

  protect_from_forgery

  include ActionView::Helpers::SanitizeHelper

  private

    # makes the data available in views
    helper_method :current_user, :airframes_index, :bookmarklet_url

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

    def authorize
      redirect_to login_url, alert: "Not authorized" if current_user.nil?

      if current_user.present?
        # for the railsjs partial; loads on every page
        @airframes_index = Airframe.find(:all, :conditions => ["created_by = ?", current_user.id], :order => "created_at DESC")
        @bookmarklet_url = "http://#{request.host_with_port}/b/#{current_user.bookmarklet_token}"
      end
    end

end

class UserLogosController < ApplicationController
    before_filter :authorize
    
    def index
      respond_to do |format|
        format.json { render :json => @current_user.logo }
      end      
    end
    
    def create

        @logo = UserLogo.new(:image => params[:image])
        
        if @logo.save && @current_user.present?
        
            if @logo.image_file_name.present?
              @current_user.logo.destroy if @current_user.logo
              @current_user.logo = @logo
            end
        end
        
        redirect_to "/profile"

    end
    
    def destroy

      @current_user.logo.destroy if @current_user.logo

      render :text => "ok"
      
    end      
    
end

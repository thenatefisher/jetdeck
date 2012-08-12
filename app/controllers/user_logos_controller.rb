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
                @current_user.logo.destroy
                @current_user.logo = @logo
              end

              redirect_to "/profile"

          end

      end
      
      def destroy

        @current_user.logo.destroy if @current_user.logo

        respond_to do |format|
            format.json { head :no_content }
        end
        
      end      
      
  end

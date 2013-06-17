class AccessoriesController < ApplicationController
  before_filter :authorize
  
  def index
  
    if params[:airframe] && Airframe.find(:first, :conditions => ["user_id = ? AND id = ?", @current_user.id, params[:airframe]])
      @assys = Airframe.find(:first, :conditions => ["user_id = ? AND id = ?", @current_user.id, params[:airframe]])
                       .images.find(:all, :order => "created_at DESC")
      render :json => @assys.collect { |p| p.to_jq_upload }.to_json
    else
      render :json => true
    end
    
  end

  def create

    @Assy = Accessory.new(params[:files])
    @Assy.creator = @current_user
    if Airframe.find(:first, :conditions => ["user_id = ? AND id = ?", @current_user.id, params[:airframe]]).present?     
      @airframe = Airframe.find(:first, :conditions => ["user_id = ? AND id = ?", @current_user.id, params[:airframe]])
      if @airframe.present?
        @Assy.airframe_id = @airframe.id
        
        if @Assy.document_file_name.present?
          @airframe.specs << @Assy
        else
          @airframe.images.each do |t|
            t.thumbnail = false
            t.save
          end
          @Assy.thumbnail = true
        end
      end
    end

    if @Assy.save
      respond_to do |format|
        format.html {
          render :json => {"files" => [@Assy.to_jq_upload]}.to_json,
                  :content_type => 'text/html',
                  :layout => false
        }
        format.json {
          render :json => {"files" => [@Assy.to_jq_upload]}.to_json
        }
      end
    else
      render :json => @Assy.errors.to_json(), :status => 304
    end

  end

  def update
  
    @Assy = Accessory.find(params[:id])
    if @Assy.airframe.user_id == @current_user.id
      if params[:thumbnail] && @Assy.present?
          @Assy.airframe.images.each { |a| a.thumbnail = false; a.save }
          @Assy.thumbnail = true
      end

      respond_to do |format|
        if @Assy.update_attributes(params[:accessory].slice(:enabled))
          format.json { head :no_content }
        else
          format.html { render :action => "edit" }
          format.json { render :json => @Assy.errors, :status => :unprocessable_entity }
        end
      end
    end
    
  end

  def destroy
    
    @Assy = Accessory.find(params[:id])
    if @Assy.airframe.user_id == @current_user.id
      @Assy.destroy
      render :json => true
    end
    
  end
  
end

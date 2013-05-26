class AccessoriesController < ApplicationController
  before_filter :authorize
  
  def index
  
    if params[:airframe] && Airframe.find(:first, :conditions => ["user_id = ? AND id = ?", @current_user.id, params[:airframe]])
      @assys = Airframe.find(:first, :conditions => ["user_id = ? AND id = ?", @current_user.id, params[:airframe]]).accessories
      render :json => @assys.collect { |p| p.to_jq_upload }.to_json
    else
      render :json => true
    end
    
  end

  def create

    @Assy = Accessory.new(params[:files])
    if Airframe.find(:first, :conditions => ["user_id = ? AND id = ?", @current_user.id, params[:airframe]]).present?
      @Assy.airframe_id = params[:airframe]
      @airframe = Airframe.find(:first, :conditions => ["user_id = ? AND id = ?", @current_user.id, params[:airframe]])
      @airframe.accessories.each do |t|
        t.thumbnail = false
        t.save
      end
      @Assy.thumbnail = true
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
      render :json => [{:error => "custom_failure"}], :status => 304
    end

  end

  def update
  
    @Assy = Accessory.find(params[:id])
    if @Assy.airframe.user_id == @current_user.id
      if params[:thumbnail] && @Assy.present?
          @Assy.airframe.accessories.each { |a| a.thumbnail = false; a.save }
          @Assy.thumbnail = true
      end

      respond_to do |format|
        if @Assy.update_attributes(params[:accessory])
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

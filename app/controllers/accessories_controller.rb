class AccessoriesController < ApplicationController

  def index
    if params[:airframe]
      @assys = Airframe.find(params[:airframe]).accessories
      render :json => @assys.collect { |p| p.to_jq_upload }.to_json
    else
      render :json => true
    end
  end

  def create

    @Assy = Accessory.new(params[:files])
    if Airframe.find(params[:airframe]).present?
      @Assy.airframe_id = params[:airframe]
      @airframe = Airframe.find(params[:airframe])
      @airframe.accessories.each do |t|
        t.thumbnail = false
        t.save
      end
      @Assy.thumbnail = true

    end

    if @Assy.save
      respond_to do |format|
        format.html {
          render :json => [@Assy.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json {
          render :json => [@Assy.to_jq_upload].to_json
        }
      end
    else
      render :json => [{:error => "custom_failure"}], :status => 304
    end

  end

  def destroy
    @Assy = Accessory.find(params[:id])
    @Assy.destroy
    render :json => true
  end
end

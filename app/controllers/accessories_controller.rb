class AccessoriesController < ApplicationController

  def index
    @assys = Accessory.all
    render :json => @assys.collect { |p| p.to_jq_upload }.to_json
  end

  def create
    @picture = Accessory.new(params[:files])
    if @picture.save
      respond_to do |format|
        format.html {
          render :json => [@picture.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json {
          render :json => [@picture.to_jq_upload].to_json
        }
      end
    else
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end

  def destroy
    @picture = Accessory.find(params[:id])
    @picture.destroy
    render :json => true
  end
end

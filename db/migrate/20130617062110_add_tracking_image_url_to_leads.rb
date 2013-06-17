class AddTrackingImageUrlToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :tracking_image_url_code, :string
  end
end

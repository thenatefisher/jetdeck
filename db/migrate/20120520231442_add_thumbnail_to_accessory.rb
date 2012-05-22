class AddThumbnailToAccessory < ActiveRecord::Migration
  def change
    add_column :accessories, :thumbnail, :boolean

  end
end

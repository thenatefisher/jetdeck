class AddPhotosToXspecs < ActiveRecord::Migration
  def change
    add_column :xspecs, :photos_enabled, :boolean
    add_column :xspecs, :spec_enabled, :boolean
  end
end

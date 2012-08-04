class AddHideLocationToXspecs < ActiveRecord::Migration
  def change


    add_column :xspecs, :hide_location, :boolean

  end
end

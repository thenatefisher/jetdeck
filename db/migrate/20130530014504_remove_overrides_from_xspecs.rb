class RemoveOverridesFromXspecs < ActiveRecord::Migration
  def up
    remove_column :xspecs, :override_price
    remove_column :xspecs, :override_description
    remove_column :xspecs, :show_message
    remove_column :xspecs, :hide_price
    remove_column :xspecs, :hide_serial
    remove_column :xspecs, :hide_registration
    remove_column :xspecs, :hide_location
  end

  def down
  end
end

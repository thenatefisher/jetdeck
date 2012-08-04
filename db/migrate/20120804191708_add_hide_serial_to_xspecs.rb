class AddHideSerialToXspecs < ActiveRecord::Migration
  def change


    add_column :xspecs, :hide_serial, :boolean

  end
end

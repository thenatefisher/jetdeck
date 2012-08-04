class AddHideRegToXspecs < ActiveRecord::Migration
  def change


    add_column :xspecs, :hide_registration, :boolean

  end
end

class AddShowMessageToXspecs < ActiveRecord::Migration
  def change

    add_column :xspecs, :show_message, :boolean

  end
end

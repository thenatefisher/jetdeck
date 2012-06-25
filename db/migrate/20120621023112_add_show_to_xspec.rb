class AddShowToXspec < ActiveRecord::Migration
  def change
    add_column :xspecs, :show, :boolean

  end
end

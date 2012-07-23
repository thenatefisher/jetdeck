class AddBackgroundIdToXspec < ActiveRecord::Migration
  def change
    add_column :xspecs, :background_id, :integer

  end
end
